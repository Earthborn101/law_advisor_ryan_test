defmodule LawAdvisorTest.Repo do
  use Ecto.Repo,
    otp_app: :law_advisor_test,
    adapter: Ecto.Adapters.Postgres
end
