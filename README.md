# LawAdvisorTest

To use this test application, perform the following steps:
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Run `mix seeds` to insert test data for users and tasks.
  * Start Phoenix endpoint with `mix phx.server`.
  * Use `/api/login` api to acquire bearer token to access `/api/tasks` endpoints.

## Note
  * Still need to improve error handlers. Proceeded to develop happy path test.

## API endpoints
  * ### /api/login
    * Login
    ```
    %{
      username: "sample",
      password: "password"
    }
    ```
    https://loom.com/share/281bbdfe4d274096bca8f32f1406764d
  * ### /api/tasks
    * Fetch list of task with `order` column order_by asc. 
    * Requires user token
    ```
    no params
    ```
    https://loom.com/share/6414670767af4b61926849917f349173
  * ### /api/tasks/create
    * Create new task
    * Requires user token
    ```
    %{
      description: "Sample description",
      title: "Sample Title
    }
    ```
    https://loom.com/share/383e32d4befa45f6b868bf397e9c97ab
  * ### /api/tasks/delete
    * Delete task
    * Requires user token
    ```
    %{
      task_id: 1
    }
    ```
    https://loom.com/share/bf46e3ad806b4816b0f50eb3b08465ab
  * ### /api/tasks/update
    * Update task
    ```
    %{
      task_id: 1,
      description: "Sample description",
      title: "Sample Title",
      status: true
    }
    ```
    https://loom.com/share/9e7cad1e7e6b4e8aa79dee76a9d13523
  * ### /api/tasks/reorder
    * Reorder task list
    * Requires user token

    ```
    %{
      task_id: 1,
      order: 5
    }
    ```
    https://loom.com/share/4868003b9a064984aa3a1929deaa4abe
