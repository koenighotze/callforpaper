defmodule Callforpapers.Validators do
  import Ecto.Changeset

  def validate_before(changeset, before_date_field, after_date_field, options \\ []) do
    validate_change(changeset,
                    before_date_field,
                    fn _, _ ->
                      %{^before_date_field => start_date,
                        ^after_date_field =>  end_date} = changeset.changes

                      if start_date < end_date do
                        []
                      else
                        [{before_date_field, options[:message] || "is invalid (#{start_date}). Must be before '#{after_date_field}' (#{end_date})"}]
                      end
                    end)
  end


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