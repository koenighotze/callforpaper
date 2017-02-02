defmodule Callforpapers.Validators do
  import Ecto.Changeset

  def validate_enum(changeset, field, allowed, options \\ []) do
    validate_change(changeset,
                    field,
                    fn _, role ->
                      if role in allowed do
                        []
                      else
                        [{field, options[:message] || "is invalid"}]
                      end
                    end)
  end
end