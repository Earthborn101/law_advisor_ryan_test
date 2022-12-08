# LawAdvisorTest

To use this test application, perform the following steps:
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Run `mix seeds` to insert test users.
  * Start Phoenix endpoint with `mix phx.server`.

## API endpoints

  * ### /api/tasks/create
    * Create new task
    ```
    %{
      description: "Sample description",
      title: "Sample Title
    }
    ```
