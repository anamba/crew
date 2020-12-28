defmodule CrewWeb.LayoutView do
  use CrewWeb, :view

  def generate_qrcode(uri) do
    uri
    |> EQRCode.encode()
    |> EQRCode.svg(width: 264)
    |> Phoenix.HTML.raw()
  end

  def twbutton(label, url) do
    [:safe, "<a href=\"", url, "\" class=\"bg-blue text-white\">", label, "</a>"]
  end

  def twsubmit(label) do
    [:safe, "<input type=\"submit\" value=\"", label, "\" class=\"bg-blue text-white\">"]
  end
end
