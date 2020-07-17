defmodule Crew.SitesTest do
  use Crew.DataCase

  alias Crew.Sites

  describe "sites" do
    alias Crew.Sites.Site

    @valid_attrs %{description: "some description", name: "some name", slug: "some slug"}
    @update_attrs %{description: "some updated description", name: "some updated name", slug: "some updated slug"}
    @invalid_attrs %{description: nil, name: nil, slug: nil}

    def site_fixture(attrs \\ %{}) do
      {:ok, site} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sites.create_site()

      site
    end

    test "list_sites/0 returns all sites" do
      site = site_fixture()
      assert Sites.list_sites() == [site]
    end

    test "get_site!/1 returns the site with given id" do
      site = site_fixture()
      assert Sites.get_site!(site.id) == site
    end

    test "create_site/1 with valid data creates a site" do
      assert {:ok, %Site{} = site} = Sites.create_site(@valid_attrs)
      assert site.description == "some description"
      assert site.name == "some name"
      assert site.slug == "some slug"
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sites.create_site(@invalid_attrs)
    end

    test "update_site/2 with valid data updates the site" do
      site = site_fixture()
      assert {:ok, %Site{} = site} = Sites.update_site(site, @update_attrs)
      assert site.description == "some updated description"
      assert site.name == "some updated name"
      assert site.slug == "some updated slug"
    end

    test "update_site/2 with invalid data returns error changeset" do
      site = site_fixture()
      assert {:error, %Ecto.Changeset{}} = Sites.update_site(site, @invalid_attrs)
      assert site == Sites.get_site!(site.id)
    end

    test "delete_site/1 deletes the site" do
      site = site_fixture()
      assert {:ok, %Site{}} = Sites.delete_site(site)
      assert_raise Ecto.NoResultsError, fn -> Sites.get_site!(site.id) end
    end

    test "change_site/1 returns a site changeset" do
      site = site_fixture()
      assert %Ecto.Changeset{} = Sites.change_site(site)
    end
  end

  describe "site_members" do
    alias Crew.Sites.SiteMember

    @valid_attrs %{person_id: "some person_id", site_id: "some site_id"}
    @update_attrs %{person_id: "some updated person_id", site_id: "some updated site_id"}
    @invalid_attrs %{person_id: nil, site_id: nil}

    def site_member_fixture(attrs \\ %{}) do
      {:ok, site_member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sites.create_site_member()

      site_member
    end

    test "list_site_members/0 returns all site_members" do
      site_member = site_member_fixture()
      assert Sites.list_site_members() == [site_member]
    end

    test "get_site_member!/1 returns the site_member with given id" do
      site_member = site_member_fixture()
      assert Sites.get_site_member!(site_member.id) == site_member
    end

    test "create_site_member/1 with valid data creates a site_member" do
      assert {:ok, %SiteMember{} = site_member} = Sites.create_site_member(@valid_attrs)
      assert site_member.person_id == "some person_id"
      assert site_member.site_id == "some site_id"
    end

    test "create_site_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sites.create_site_member(@invalid_attrs)
    end

    test "update_site_member/2 with valid data updates the site_member" do
      site_member = site_member_fixture()
      assert {:ok, %SiteMember{} = site_member} = Sites.update_site_member(site_member, @update_attrs)
      assert site_member.person_id == "some updated person_id"
      assert site_member.site_id == "some updated site_id"
    end

    test "update_site_member/2 with invalid data returns error changeset" do
      site_member = site_member_fixture()
      assert {:error, %Ecto.Changeset{}} = Sites.update_site_member(site_member, @invalid_attrs)
      assert site_member == Sites.get_site_member!(site_member.id)
    end

    test "delete_site_member/1 deletes the site_member" do
      site_member = site_member_fixture()
      assert {:ok, %SiteMember{}} = Sites.delete_site_member(site_member)
      assert_raise Ecto.NoResultsError, fn -> Sites.get_site_member!(site_member.id) end
    end

    test "change_site_member/1 returns a site_member changeset" do
      site_member = site_member_fixture()
      assert %Ecto.Changeset{} = Sites.change_site_member(site_member)
    end
  end
end
