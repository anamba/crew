defmodule Crew.Persons.Person do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crew.Persons.{PersonRel, PersonTagging}
  alias Crew.Sites.Site

  @indexed_fields %{
    site_id: %{type: "keyword"},
    email: %{type: "text", analyzer: "keyword_case_insensitive"},
    email2: %{type: "text", analyzer: "keyword_case_insensitive"},
    email3: %{type: "text", analyzer: "keyword_case_insensitive"},
    first_name: %{type: "text"},
    middle_names: %{type: "text"},
    last_name: %{type: "text"},
    suffix: %{type: "text"},
    preferred_name: %{type: "text"},
    phone1: %{type: "text"},
    phone2: %{type: "text"},
    profile: %{type: "text"},
    note: %{type: "text"},
    batch_note: %{type: "text"},
    tags: %{type: "text"}
  }

  @queried_fields [
    "email",
    "email2",
    "email3",
    "first_name",
    "middle_names",
    "last_name",
    "suffix",
    "preferred_name",
    "phone1",
    "phone2",
    # "email^3",
    # "email2^2",
    # "email3^2",
    # "first_name^4",
    # "middle_names^4",
    # "last_name^5",
    # "preferred_name^4",
    # "phone1^3",
    # "phone2^3",
    "profile",
    "note",
    "batch_note",
    "tags"
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "persons" do
    belongs_to :site, Site
    has_many :taggings, PersonTagging
    has_many :tags, through: [:taggings, :tag]
    has_many :out_rels, PersonRel, foreign_key: :src_person_id
    has_many :in_rels, PersonRel, foreign_key: :dest_person_id

    # 1. primary identifier for a Person not tied to a User
    # 2. for a Person with a User, does not have to be the same email
    # 3. used for notifications (appt reminders, etc.)
    field :email, :string

    # alternate email addresses (not exposed in UI, mainly used for importing)
    field :email2, :string
    field :email3, :string

    # temporarily store new email address here if person wants to change their email address
    field :new_email, :string

    # for generating email TOTP codes
    field :totp_secret_base32, :string

    field :name, :string

    field :prefix, :string
    field :first_name, :string
    field :middle_names, :string
    field :last_name, :string
    field :suffix, :string

    field :preferred_name, :string
    field :preferred_pronouns, :string

    # if name was imported from a file, store the original version before splitting/processing
    field :original_name, :string

    # used to identify unique records imported from an external data source
    field :extid, :string

    field :note, :string
    field :profile, :string

    field :phone1, :string
    field :phone1_type, :string
    field :phone2, :string
    field :phone2_type, :string

    # for custom fields
    field :metadata_json, :string

    # legally considered an adult for the purpose of our and tenant's T&Cs
    field :adult, :boolean, default: true, null: false

    # vs. physical, i.e. can be in more than one place at once
    field :virtual, :boolean, default: false

    # i.e. not an individual
    field :group, :boolean, default: false

    # to allow mass-created records to be edited/deleted together as well
    field :batch_id, :binary_id
    field :batch_note, :string

    field :needs_review, :boolean
    field :needs_review_reason, :string

    field :email_confirmed_at, :utc_datetime

    field :email_opted_in_at, :utc_datetime
    field :email_opted_out_at, :utc_datetime

    field :discarded_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [
      :email,
      :name,
      :prefix,
      :first_name,
      :middle_names,
      :last_name,
      :suffix,
      :profile,
      :original_name,
      :extid,
      :note,
      :phone1,
      :phone1_type,
      :phone2,
      :phone2_type,
      :adult,
      :virtual,
      :group,
      :batch_id,
      :needs_review,
      :needs_review_reason
    ])
    |> put_name()
    |> put_totp_secret()
    |> validate_required([:name])

    # |> put_search_index()
  end

  def profile_changeset(person, attrs) do
    person
    |> cast(attrs, [
      :name,
      :prefix,
      :first_name,
      :middle_names,
      :last_name,
      :suffix,
      :profile,
      :phone1,
      :phone1_type,
      :phone2,
      :phone2_type
    ])
    |> put_name()
    |> validate_required([:first_name, :last_name])

    # |> put_search_index()
  end

  @doc false
  def change_email_changeset(person, attrs) do
    person
    |> cast(attrs, [:new_email])
    |> put_totp_secret()
    |> validate_required([:new_email])
  end

  def confirm_email(person) do
    person
    |> change(%{
      email: person.new_email,
      email_confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
    })

    # |> put_search_index()
  end

  # @doc false
  # def reindex_changeset(person) do
  #   person
  #   |> change()
  #   |> put_search_index()
  # end

  def put_name(changeset) do
    # if first or last name is changed AND name field is not being changed manually, set it automatically
    if !get_change(changeset, :name) &&
         (get_change(changeset, :first_name) || get_change(changeset, :last_name)) do
      first_name = get_field(changeset, :first_name)
      last_name = get_field(changeset, :last_name)
      # FIXME - probably too simplistic
      put_change(
        changeset,
        :name,
        [first_name, last_name] |> Enum.filter(&((&1 || "") != "")) |> Enum.join(" ")
      )
    else
      changeset
    end
  end

  def elasticsearch_mapping, do: @indexed_fields

  def elasticsearch_query_fields, do: @queried_fields

  def elasticsearch_data(person) do
    person = Crew.Repo.preload(person, [:taggings])

    map =
      Enum.reduce(Map.keys(@indexed_fields), %{}, fn key, map ->
        Map.put(map, key, Map.get(person, key))
      end)

    Map.put(
      map,
      :tags,
      Enum.flat_map(person.taggings, fn tagging ->
        [tagging.name, tagging.value, "#{tagging.value_i}"]
      end)
      |> Enum.join(" ")
    )
  end

  # def put_search_index(%{valid?: false} = changeset), do: changeset

  # def put_search_index(changeset) do
  #   person = changeset.data |> Crew.Repo.preload(:taggings)

  #   values =
  #     (Enum.map(@indexed_fields, &get_field(changeset, &1)) ++
  #        Enum.flat_map(person.taggings, fn tagging ->
  #          [tagging.name, tagging.value, "#{tagging.value_i}"]
  #        end))
  #     |> Enum.filter(&((&1 || "") != ""))
  #     |> Enum.map(&(&1 <> " " <> String.replace(&1, ~r/[^\w\d\s]/, "")))
  #     |> Enum.flat_map(&String.split(&1, " "))
  #     |> Enum.uniq()

  #   put_change(changeset, :search_index, Enum.join(values, "\n"))
  # end

  def put_totp_secret(changeset) do
    if get_field(changeset, :totp_secret_base32) do
      changeset
    else
      secret = NimbleTOTP.secret(10)
      put_change(changeset, :totp_secret_base32, Base.encode32(secret, padding: false))
    end
  end

  def discard(obj) do
    change(obj, %{discarded_at: DateTime.utc_now() |> DateTime.truncate(:second)})
  end

  # generate codes valid for 30 minutes (but say 20, perhaps)
  @totp_period 1800

  def generate_totp_code(person) do
    {:ok, secret} = Base.decode32(person.totp_secret_base32)
    NimbleTOTP.verification_code(secret, period: @totp_period)
  end

  def verify_totp_code(person, otp) do
    {:ok, secret} = Base.decode32(person.totp_secret_base32)
    NimbleTOTP.valid?(secret, otp, period: @totp_period)
  end

  @prefixes ~w[Mrs Mr Ms Miss Dr Reverend Hon Professor Prof Gen Brig Maj Sgt CAPT Capt CDR Cmdr LTC LCDR Col The\\sRev]
  @suffixes ~w[Jr III II IV Sr CPA MD M\\.D\\. Ph\\.D PhD]
  @common_second_first_names ~w(Ann)
  @common_first_last_names ~w(De Van)
  # @common_korean_chinese_vietnamese_names [
  #   "Bae",
  #   "Chang",
  #   "Cho",
  #   "Choi",
  #   "Choo",
  #   "Choy",
  #   "Chu",
  #   "Dang",
  #   "He",
  #   "Hong",
  #   "Jang",
  #   "Jiang",
  #   "Jin",
  #   "Ki",
  #   "Kim",
  #   "Kong",
  #   "Lee",
  #   "Leung",
  #   "Moon",
  #   "Nguyen",
  #   "Park",
  #   "Sun",
  #   "Tan",
  #   "Tran",
  #   "Wu",
  #   "Xia",
  #   "Xian",
  #   "Zhang"
  # ]

  @doc """
      NOTE: Parser is extremely conservative wrt to middle names, and will only look for middle initials.

      iex> Crew.Persons.Person.parse_name("Mr. Aaron Namba")
      {:ok, %{prefix: "Mr.", first_name: "Aaron", middle_names: "", last_name: "Namba", suffix: nil, grad_year: nil, needs_review: false, needs_review_reason: nil}}
      iex> Crew.Persons.Person.parse_name("Mr. Aaron O'Namba")
      {:ok, %{prefix: "Mr.", first_name: "Aaron", middle_names: "", last_name: "O'Namba", suffix: nil, grad_year: nil, needs_review: false, needs_review_reason: nil}}
      iex> Crew.Persons.Person.parse_name("Mr. Aaron De Namba")
      {:ok, %{prefix: "Mr.", first_name: "Aaron", middle_names: "", last_name: "De Namba", suffix: nil, grad_year: nil, needs_review: false, needs_review_reason: nil}}
      iex> Crew.Persons.Person.parse_name("Ms. Aaron Ann Namba")
      {:ok, %{prefix: "Ms.", first_name: "Aaron Ann", middle_names: "", last_name: "Namba", suffix: nil, grad_year: nil, needs_review: false, needs_review_reason: nil}}
      iex> Crew.Persons.Person.parse_name("Aaron Ann Namba")
      {:ok, %{prefix: "", first_name: "Aaron Ann", middle_names: "", last_name: "Namba", suffix: nil, grad_year: nil, needs_review: false, needs_review_reason: nil}}
      iex> Crew.Persons.Person.parse_name("Mrs. Aaron K. Namba")
      {:ok, %{prefix: "Mrs.", first_name: "Aaron", middle_names: "K.", last_name: "Namba", suffix: nil, grad_year: nil, needs_review: false, needs_review_reason: nil}}
      iex> Crew.Persons.Person.parse_name("Mrs. Aaron K. Hamada")
      {:ok, %{prefix: "Mrs.", first_name: "Aaron", middle_names: "K.", last_name: "Hamada", suffix: nil, grad_year: nil, needs_review: false, needs_review_reason: nil}}
      iex> Crew.Persons.Person.parse_name("Mr. Aaron K. Namba, Jr.")
      {:ok, %{prefix: "Mr.", first_name: "Aaron", middle_names: "K.", last_name: "Namba", suffix: "Jr.", grad_year: nil, needs_review: false, needs_review_reason: nil}}
      iex> Crew.Persons.Person.parse_name("The Rev. Aaron K. Namba")
      {:ok, %{prefix: "The Rev.", first_name: "Aaron", middle_names: "K.", last_name: "Namba", suffix: nil, grad_year: nil, needs_review: false, needs_review_reason: nil}}
      iex> Crew.Persons.Person.parse_name("Mr. Aaron-Aaron Namba, IV")
      {:ok, %{prefix: "Mr.", first_name: "Aaron-Aaron", middle_names: "", last_name: "Namba", suffix: "IV", grad_year: nil, needs_review: false, needs_review_reason: nil}}
      iex> Crew.Persons.Person.parse_name("Mrs. Aaron Aaron Namba, IV")
      {:ok, %{prefix: "Mrs.", first_name: "Aaron", middle_names: "Aaron", last_name: "Namba", suffix: "IV", grad_year: nil, needs_review: true, needs_review_reason: "Please check name (format was ambiguous)"}}
      iex> Crew.Persons.Person.parse_name("Mrs. Aaron Aaron Namba")
      {:ok, %{prefix: "Mrs.", first_name: "Aaron", middle_names: "Aaron", last_name: "Namba", suffix: nil, grad_year: nil, needs_review: true, needs_review_reason: "Please check name (format was ambiguous)"}}
  """
  def parse_name(name, last_name_hint \\ "") when not is_nil(name) do
    name = capitalize_name(name)
    prefixes = "(?:#{Enum.join(@prefixes, "|")})(?:\\.|\\s|\\.\\s)?"
    second_first_names = "(?:\\s(?:#{Enum.join(@common_second_first_names, "|")}))?"
    first_last_names = "(?:(?:#{Enum.join(@common_first_last_names, "|")})\\s)?"
    suffixes = "(?:#{Enum.join(@suffixes, "|")})(?:\\.|\\s|\\.\\s)?"

    name_regex1 = ~r/^          # name with middle initials
      ((?:#{prefixes})*)        # prefixes
      \s*
      ([^\.]+?)                 # first name
      \s+
      ([A-Z]\.(?:\s?[A-Z]\.?)*) # middle initials
      \s+
      ([-'\w\s]+)               # last name
      (?:,?\s(#{suffixes}))?    # suffix
      (?:\s('\d{2}))?           # class year
    $/x

    name_regex2 = ~r/^ # name with middle initials, no periods
      ((?:#{prefixes})*)                # prefixes
      \s*
      ([^\.]+?)                         # first name
      \s+
      ((?:[BCDFJHJKLMNPQRSTVWXYZ])+)    # non-vowel middle initials without period
      \s+
      ([^\.]+?)                         # last name
      (?:,?\s(#{suffixes}))?            # suffix
      (?:\s('\d{2}))?                   # class year
    $/x

    name_regex3 = ~r/^ # no middle initials, no spaces in name except for common cases
      ((?:#{prefixes})*)                # prefixes
      \s*
      ([^\s\.]+?#{second_first_names})  # first name, no spaces, no periods
      (\s+)
      (#{first_last_names}[^\s\.]+?)    # last name, no spaces, no periods
      (?:,?\s(#{suffixes}))?            # suffix, rigid
      (?:\s('\d{2}))?                   # class year
    $/x

    _name_regex4 = ~r/^ # matches student's name
      ((?:#{prefixes})*)                # prefixes
      ([^\.]+?)                         # first name, no periods
      \s+
      (#{Regex.escape(last_name_hint)}|#{Regex.escape(last_name_hint) |> String.replace("-", " ")}) # last name matching student
      (?:,?\s(#{suffixes}))?            # suffix, rigid
      (?:\s('\d{2}))?                   # class year
    $/x

    name_regex6 = ~r/^ # try to interpret as first and middle, flag for review
      ((?:#{prefixes})*)                # prefixes
      ([^\.\s]+)                        # first name, no periods, no spaces
      \s+
      ([^\.\s]+)                        # middle name, no periods, no spaces
      \s+
      (.+?)                             # last name, spaces allowed
      (?:,?\s(#{suffixes}))?            # suffix?
      (?:\s('\d{2}))?                   # class year
    $/x

    name_regex7 = ~r/^ # allow spaces in names, but require suffix and flag for review
      ((?:#{prefixes})*)                # prefixes
      ([^\.]+)                          # first name, no periods
      (\s+)
      (.+?)                             # last name, spaces allowed
      (?:,?\s(#{suffixes}))             # suffix
      (?:\s('\d{2}))?                   # class year
    $/x

    name_regex8 = ~r/^ # allow periods in names, but flag for review
      ((?:#{prefixes})*)                # prefixes
      (.+)                              # first name
      (\s+)
      (.+?)                             # last name, spaces allowed
      (?:,?\s(#{suffixes}))?            # suffix?
      (?:\s('\d{2}))?                   # class year
    $/x

    # the "normal" patterns
    result1 = Regex.run(name_regex1, name)
    result2 = Regex.run(name_regex2, name)
    result3 = Regex.run(name_regex3, name)

    # the "last resort" patterns, flag for review
    # result4
    # result5
    result6 = Regex.run(name_regex6, name)
    result7 = Regex.run(name_regex7, name)
    result8 = Regex.run(name_regex8, name)

    case (result1 || result2 || result3 || [])
         |> Enum.map(&String.trim/1)
         |> Enum.map(&capitalize_name/1) do
      [] ->
        # try last resort matches
        case (result6 || result7 || result8 || [])
             |> Enum.map(&String.trim/1)
             |> Enum.map(&capitalize_name/1) do
          [] ->
            {:error, "Did not match any known name patterns: #{name}"}

          [_, prefix, first_name, middle_names, last_name | rest] ->
            # IO.puts("parse_name: Name matched forms #4-7: #{name}")

            # FIXME: if only first and last name and neither has spaces, then we're probably ok

            # FIXME: shouldn't be parsing grad_year here...
            {:ok,
             %{
               prefix: prefix,
               first_name: first_name,
               middle_names: middle_names,
               last_name: last_name,
               suffix: Enum.at(rest, 0),
               grad_year: Enum.at(rest, 1),
               needs_review: true,
               needs_review_reason: "Please check name (format was ambiguous)"
             }}
        end

      [_, prefix, first_name, middle_names, last_name | rest] ->
        # IO.puts("parse_name: Name matched forms #1-3: #{name}")

        # FIXME: shouldn't be parsing grad_year here...
        {:ok,
         %{
           prefix: prefix,
           first_name: first_name,
           middle_names: middle_names,
           last_name: last_name,
           suffix: Enum.at(rest, 0),
           grad_year: Enum.at(rest, 1),
           needs_review: false,
           needs_review_reason: nil
         }}
    end
  end

  @doc """
      iex> Crew.Persons.Person.parse_name_reversed("Namba, Aaron")
      {:ok, %{first_name: "Aaron", last_name: "Namba", middle_names: nil, suffix: nil}}
      iex> Crew.Persons.Person.parse_name_reversed("Namba, Aaron K. Jr.")
      {:ok, %{first_name: "Aaron", last_name: "Namba", middle_names: "K.", suffix: "Jr."}}
      iex> Crew.Persons.Person.parse_name_reversed("Namba Jr., Aaron")
      {:ok, %{first_name: "Aaron", last_name: "Namba", middle_names: nil, suffix: "Jr."}}
      iex> Crew.Persons.Person.parse_name_reversed("Namba, Aaron K")
      {:ok, %{first_name: "Aaron", middle_names: "K", last_name: "Namba", suffix: nil}}
      iex> Crew.Persons.Person.parse_name_reversed("O'Namba, Aaron K")
      {:ok, %{first_name: "Aaron", middle_names: "K", last_name: "O'Namba", suffix: nil}}
  """
  def parse_name_reversed(name) do
    name = capitalize_name(name)
    suffixes = "(?:#{Enum.join(@suffixes, "|")})(?:\\.|\\s|\\.\\s)?"
    name_regex = ~r/^
      (.+?),                                # last name
      \s
      (.+?)                                 # first name
      ([A-Z]|(?:[A-Z]\.(?:\s?[A-Z]\.?)*))?  # middle names
      (?:\s(#{suffixes}))?                  # suffix
    $/x

    case (Regex.run(name_regex, name) || [])
         |> Enum.map(&String.trim/1)
         |> Enum.map(&capitalize_name/1) do
      [] ->
        {:error, "Could not parse reversed name"}

      [_, last_name, first_name, middle_name, suffix] ->
        {:ok,
         %{
           first_name: first_name,
           middle_names: middle_name,
           last_name: last_name,
           suffix: suffix
         }}

      [_, last_name, first_name | rest] ->
        suffix = Enum.at(rest, 1)

        {suffix, first_name} =
          case Regex.run(~r/^(#{suffixes}),\s*(.+?)$/i, first_name) do
            nil -> {suffix, first_name}
            [_, suffix, first_name] -> {suffix, first_name}
          end

        {suffix, last_name} =
          case Regex.run(~r/^(.+?)\s(#{suffixes})$/i, last_name) do
            nil -> {suffix, last_name}
            [_, last_name, suffix] -> {suffix, last_name}
          end

        {:ok,
         %{
           first_name: first_name,
           middle_names: Enum.at(rest, 0),
           last_name: last_name,
           suffix: capitalize_suffix(suffix)
         }}
    end
  end

  @doc """
      iex> Crew.Persons.Person.parse_last_name_with_suffix("NAMBA III")
      {:ok, %{last_name: "Namba", suffix: "III"}}
      iex> Crew.Persons.Person.parse_last_name_with_suffix("O'NAMBA III")
      {:ok, %{last_name: "O'Namba", suffix: "III"}}
  """
  def parse_last_name_with_suffix(name) do
    name = capitalize_name(name)
    suffixes = "(?:#{Enum.join(@suffixes, "|")})(?:\\.|\\s|\\.\\s)?"
    name_regex = ~r/^
      (.+?)                 # last name
      (?:\s(#{suffixes}))?  # suffix
    $/x

    case (Regex.run(name_regex, name) || [])
         |> Enum.map(&String.trim/1)
         |> Enum.map(&capitalize_name/1) do
      [] ->
        {:error, "Could not parse last name with suffix"}

      [_, last_name, suffix] ->
        {:ok,
         %{
           last_name: last_name,
           suffix: suffix
         }}

      [_, last_name] ->
        {:ok,
         %{
           last_name: last_name
         }}
    end
  end

  def capitalize_suffix(nil), do: nil

  def capitalize_suffix(suffix) do
    # just replace based on known suffixes
    Enum.reduce(@suffixes, suffix, fn known_suffix, suffix ->
      String.replace(suffix, ~r/^#{known_suffix}$/i, known_suffix)
    end)
  end

  @doc """
      iex> Crew.Persons.Person.capitalize_name("MR. AARON 'AINA K.L.M. KIM O'MCNAMBA-MACLEE, JR.")
      "Mr. Aaron 'Aina K.L.M. Kim O'McNamba-MacLee, Jr."
  """
  def capitalize_name(nil), do: nil

  def capitalize_name(name) do
    # tokenize string into an ordered list of content and separators
    # then just capitalize each string in the list and join
    ["-", " ", ".", ",", "mc", "mac", "o'"]
    |> Enum.reduce([String.downcase(name)], fn sep, names ->
      Enum.flat_map(names, &(String.split(&1, sep) |> Enum.intersperse(sep)))
    end)
    |> Enum.map_join(fn name ->
      if Enum.any?(@suffixes, &(String.downcase(&1) == String.downcase(name))) do
        capitalize_suffix(name)
      else
        # special case: starts with '
        case String.split(name, "'") do
          ["", rest] -> "'#{String.capitalize(rest)}"
          _ -> String.capitalize(name)
        end
      end
    end)
  end
end
