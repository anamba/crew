alias Crew.Persons.Person
alias Crew.Sites.{Site, SiteMember}

defimpl Canada.Can, for: Person do
  # two assumptions for these two:
  # 1. Person is associated with the logged in User
  # 2. site_members association is preloaded
  def can?(%Person{id: person_id}, action, %Site{
        site_members: [%SiteMember{person_id: person_id, role: role}]
      })
      when role in ["owner"] and action in [:read, :create, :update, :destroy, :touch],
      do: true

  def can?(%Person{id: person_id}, action, %Site{
        site_members: [%SiteMember{person_id: person_id, role: role}]
      })
      when role in ["owner"] and action in [:read, :create, :update, :destroy, :touch],
      do: true

  def can?(%Person{id: person_id}, action, %Site{
        site_members: [%SiteMember{person_id: person_id}]
      })
      when action in [:list, :read],
      do: true
end

#
# all other can? calls operate on SiteMember after site access has been validated
#
defimpl Canada.Can, for: SiteMember do
  # everyone can edit their own Person record (demo)
  def can?(%SiteMember{person_id: person_id}, action, %Person{id: person_id})
      when action in [:read, :update],
      do: true

  # only owners can edit SiteMember (authorization) records
  def can?(%SiteMember{role: role}, action, %SiteMember{})
      when role in ["owner"] and action in [:read, :create, :update, :destroy, :touch],
      do: true

  # owners and admins can edit Person records (demo)
  def can?(%SiteMember{role: role}, action, %Person{})
      when role in ["owner", "admin"] and action in [:read, :create, :update, :destroy, :touch],
      do: true

  def can?(%SiteMember{role: role}, action, Person)
      when role in ["owner", "admin"] and action in [:list],
      do: true
end
