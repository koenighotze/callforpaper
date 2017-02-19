defmodule Callforpapers.FontAwesome do
  import FontAwesomePhoenix.HTML

  def fw_icon(name, opts \\ []) do
    fa_icon(name, [class: "fa-fw"] ++ opts)
  end
end