defmodule Callforpapers.Validators do
  import Ecto.Changeset

  def validate_enum(changeset, field, allowed, options \\ []) do
    validate_change(changeset,
                    field,
                    fn _, role ->
                      if role in allowed do
                        []
                      else
                        [{field, options[:message] || "is invalid, must be in #{Enum.join(allowed, ~s( ))}"}]
                      end
                    end)
  end
end