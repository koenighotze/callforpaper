defmodule CfpUi.SubmissionTest do
  use CfpUi.ModelCase

  alias CfpUi.Submission

  @valid_attrs %{duration_minutes: 42, reference: "some content", short_description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Submission.changeset(%Submission{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Submission.changeset(%Submission{}, @invalid_attrs)
    refute changeset.valid?
  end
end
