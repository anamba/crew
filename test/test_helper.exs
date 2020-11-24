alias Crew.Persons.Person

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Crew.Repo, :manual)

# create elasticsearch index
es_url =
  "http://#{Application.get_env(:crew, :elasticsearch_host)}" <>
    ":#{Application.get_env(:crew, :elasticsearch_port)}"

es_index = Application.get_env(:crew, :elasticsearch_index)

if Elastix.Index.exists?(es_url, es_index),
  do: Elastix.Index.delete(es_url, es_index)

# Elastix.Index.create(es_url, es_index, %{})

Elastix.HTTP.put!(
  es_url <> "/#{es_index}",
  Jason.encode!(%{
    settings: %{
      index: %{
        analysis: %{
          analyzer: %{
            keyword_case_insensitive: %{
              tokenizer: "keyword",
              filter: "lowercase"
            }
          }
        }
      }
    }
  })
)

Elastix.Mapping.put(es_url, es_index, "person", %{properties: Person.elasticsearch_mapping()},
  include_type_name: true
)
