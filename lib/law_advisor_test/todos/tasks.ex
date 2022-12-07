defmodule LawAdvisorTest.Todos.Tasks do
  @moduledoc """
  The tasks context.
  """
  import Ecto.{Changeset, Query}, warn: false

  alias Ecto.Multi
  alias LawAdvisorTest.Repo
  alias LawAdvisorTest.Todos.Task

  @doc """
  Fetch list of tasks by user id

  ## Examples

    iex> list_tasks_by_user_id(1)
    [
      %LawAdvisorTest.Todos.Task{}
    ]
  """
  def list_tasks_by_user_id(user_id) do
    query = from(t in Task, where: t.user_id == ^user_id, order_by: [asc: :order])

    query
    |> Repo.all()
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{"title" => "Sample Tasks", "description" => "Sample description"})
      {:ok, %LawAdvisorTest.Todos.Task{}}

      iex> create_task(%{"title" => "Invalid title with more than 25 characters", "description" => "Sample description"})
      {:error, changeset}
  """
  def create_task(params) do
    Task.changeset(%Task{}, params)
    |> put_order()
    |> Repo.insert()
  end

  defp put_order(%{valid?: true} = changeset) do
    user_id = fetch_field!(changeset, :user_id)

    changeset
    |> put_change(:order, count_task_by(user_id: user_id) + 1)
  end

  defp put_order(changeset), do: changeset

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(%{"task_id" => 1, "title" => "Sample Tasks", "description" => "Sample description"})
      {:ok, %LawAdvisorTest.Todos.Task{}}

      iex> update_task(%{"title" => "Invalid title with more than 25 characters", "description" => "Sample description"})
      {:error, "Enter Task id"}
  """

  def update_task(%{"task_id" => task_id} = attrs) do
    task = get_task_by(id: task_id, user_id: attrs["user_id"])

    Task.changeset_update(task, attrs)
    |> Repo.update()
  end

  def update_task(_), do: {:error, "Enter Task id"}

  @doc """
  Delete a user task

  ## Examples

      iex> delete_task(%{"task_id" => 1})
      {:ok, %LawAdvisorTest.Todos.Task{}}

      iex> delete_task(%{"task_id" => 2})
      {:error, changeset}
  """

  def delete_task(%{"task_id" => task_id} = attrs) do
    task = get_task_by(id: task_id, user_id: attrs["user_id"])

    Multi.new()
    |> Multi.run(:validate_task, fn _repo, _changes ->
      validate_delete_task_attrs(task)
    end)
    |> Multi.delete(:deleted_tasks, fn _ -> task end)
    |> Multi.update_all(
      :update_order_task,
      fn _ ->
        update_order_task_after_delete(attrs, task)
      end,
      []
    )
    |> Multi.run(:tasks, fn _repo, _changes ->
      {:ok, list_tasks_by_user_id(attrs["user_id"])}
    end)
    |> Repo.transaction()
  end

  def delete_task(_), do: {:error, "Enter Task id"}

  defp validate_delete_task_attrs(nil), do: {:error, "Invalid Task"}

  defp validate_delete_task_attrs(task), do: {:ok, task}

  defp update_order_task_after_delete(attrs, task) do
    order = task.order

    ordered_rows_subquery =
      from(t in Task,
        where: t.user_id == ^attrs["user_id"] and t.order >= ^order,
        select: %{
          id: t.id,
          order: t.order - 1
        }
      )

    update_query =
      from t in Task,
        join: new_order in subquery(ordered_rows_subquery),
        on: new_order.id == t.id,
        update: [set: [order: new_order.order]]
  end

  @doc """
  Re-order list of tasks

  ## Examples

    iex> reorder_tasks(%{task_id: 1, order: 3})
    [
      %LawAdvisorTest.Todos.Task{order: 1},
      %LawAdvisorTest.Todos.Task{order: 2},
      %LawAdvisorTest.Todos.Task{order: 3}
    ]
  """
  def reorder_tasks(attrs) do
    task = get_task_by(id: attrs["task_id"])

    Multi.new()
    |> Multi.run(:changeset, fn _repo, _changes ->
      validate_reorder_task_attrs(attrs, task)
    end)
    |> Multi.update(:update, fn %{changeset: changeset} ->
      changeset
    end)
    |> Multi.update_all(
      :update_order_task,
      fn _ ->
        update_order_task_query(attrs, task)
      end,
      []
    )
    ## Querying a new order by list of task by user after insert
    |> Multi.run(:tasks, fn _repo, _changes ->
      {:ok, list_tasks_by_user_id(attrs["user_id"])}
    end)
    |> Repo.transaction()
  end

  defp validate_task_attrs(_attrs, nil), do: {:error, "Invalid Task"}

  defp validate_reorder_task_attrs(attrs, task) do
    case Task.changeset_reorder(task, attrs) do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:ok, changeset}

      _ ->
        {:error, "Invalid Task"}
    end
  end

  defp update_order_task_query(attrs, task) do
    new_order = attrs["order"]
    old_order = task.order

    ordered_rows_subquery =
      ordered_rows_subquery(
        Decimal.compare(new_order, old_order),
        new_order,
        old_order,
        task.id,
        attrs["user_id"]
      )

    update_query =
      from t in Task,
        join: new_order in subquery(ordered_rows_subquery),
        on: new_order.id == t.id,
        update: [set: [order: new_order.order]]
  end

  defp ordered_rows_subquery(:gt, new_order, old_order, task_id, user_id) do
    from(t in Task,
      where:
        t.user_id == ^user_id and t.id != ^task_id and t.order <= ^new_order and
          t.order >= ^old_order,
      select: %{
        id: t.id,
        order: t.order - 1
      }
    )
  end

  defp ordered_rows_subquery(:lt, new_order, old_order, task_id, user_id) do
    from(t in Task,
      where:
        t.user_id == ^user_id and t.id != ^task_id and t.order >= ^new_order and
          t.order <= ^old_order,
      select: %{
        id: t.id,
        order: t.order + 1
      }
    )
  end

  @doc """
  Get task using selected clause

  ##Examples

    iex> get_task(id: id)
    {:ok, %LawAdvisorTest.Todos.Task{}}
  """
  def get_task_by(attrs) do
    Repo.get_by(Task, attrs)
  end

  @doc """
  Counts task by user_id.

  ## Examples

      iex> count_task_by_user_id(123)
      5
  """
  def count_task_by(attrs) when is_map(attrs) do
    count_task_by(Map.to_list(attrs))
  end

  def count_task_by(attrs) when is_list(attrs) do
    query =
      attrs
      |> Enum.reduce(from(t in Task, as: :task), fn
        {:id, id}, query ->
          query |> where(id: ^id)

        {:user_id, user_id}, query ->
          query |> where(user_id: ^user_id)

        _, query ->
          query
      end)

    Repo.aggregate(query, :count)
  end
end
