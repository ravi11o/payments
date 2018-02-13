defmodule PaymentsWeb.PageController do
  use PaymentsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def process_payment(conn, %{"amount" => amount, "description" => des, "stripeToken" => token}) do
    if byte_size(amount) == 0 || String.to_integer(amount) <= 0 do
      conn
      |> put_flash(:error, "Enter a valid amount")
      |> redirect(to: page_path(conn, :index))
    else
      amount_in_cents = String.to_integer(amount) * 100
      case StripePost.charge(%{amount: amount_in_cents, currency: "usd", description: des, source: token, capture: false}) do
        {200, %{"id" => id} = params} ->
          IO.inspect params
          conn
          |> render("confirm.html", id: id, amount: amount)

        {400, %{"error" => %{"message" => message}}} ->
          conn
          |> json(%{error: message})
      end
    end
  end
  def confirm_payment(conn, %{"payment_id" => id}) do
    case StripePost.capture(id) do
      {200, %{"source" => %{"name" => email, "address_zip" => zip, "last4" => last4}, "amount" => amount} = params} ->
        IO.inspect params
        amount_in_usd = div(amount, 100)
        details = %{email: email, zip: zip, last4: last4, amount: amount_in_usd}

        conn
        |> put_flash(:info, "Transaction of $#{amount_in_usd} is Successful")
        |> render("success.html", details: details)

      {400, %{"error" => %{"message" => message}}} ->
        conn
        |> json(%{error: message})
    end
  end
end
