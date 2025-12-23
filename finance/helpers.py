import requests

from flask import redirect, render_template, session
from functools import wraps


def apology(message, code=400):
    """Render message as an apology to user."""

    def escape(s):
        """
        Escape special characters.

        https://github.com/jacebrowning/memegen#special-characters
        """
        for old, new in [
            ("-", "--"),
            (" ", "-"),
            ("_", "__"),
            ("?", "~q"),
            ("%", "~p"),
            ("#", "~h"),
            ("/", "~s"),
            ('"', "''"),
        ]:
            s = s.replace(old, new)
        return s

    return render_template("apology.html", top=code, bottom=escape(message)), code


def login_required(f):
    """
    Decorate routes to require login.

    https://flask.palletsprojects.com/en/latest/patterns/viewdecorators/
    """

    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get("user_id") is None:
            return redirect("/login")
        return f(*args, **kwargs)

    return decorated_function


def lookup(symbol):
    """Look up quote for symbol."""
    import requests

    if not symbol:
        return None

    url = f"https://finance.cs50.io/quote?symbol={symbol.upper()}"
    try:
        r = requests.get(url)
        r.raise_for_status()
        q = r.json()

        # Support both possible key formats
        name = q.get("name") or q.get("companyName")
        price = q.get("price") or q.get("latestPrice")
        sym = q.get("symbol") or symbol.upper()

        if name is None or price is None:
            return None

        return {"name": name, "price": float(price), "symbol": sym}
    except Exception:
        return None



def usd(value):
    """Format value as USD."""
    return f"${value:,.2f}"
