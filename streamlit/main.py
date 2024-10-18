import os
import streamlit as st
from google.auth.transport import requests
from google.oauth2 import id_token

#jwtaudience = "/projects/568491243624/global/backendServices/2885218973683909401"
jwtaudience = os.getenv("_IAP_AUDIENCE")


def validate_iap_jwt(iap_jwt: str, expected_audience: str):
    """Validate an IAP JWT.

    Args:
      iap_jwt: The contents of the X-Goog-IAP-JWT-Assertion header.
      expected_audience: The Signed Header JWT audience. See
          https://cloud.google.com/iap/docs/signed-headers-howto
          for details on how to get this value.

    Returns:
      (user_id, user_email, error_str).
    """

    try:
        decoded_jwt = id_token.verify_token(
            iap_jwt,
            requests.Request(),
            audience=expected_audience,
            certs_url="https://www.gstatic.com/iap/verify/public_key",
        )
        return (decoded_jwt["sub"], decoded_jwt["email"], "")
    except Exception as e:
        return (None, None, f"**ERROR: JWT validation error {e}**")


if __name__ == "__main__":

    st.header("Streamlit IAP Checker")


    if "X-Goog-Authenticated-User-Email" not in st.context.headers:
        st.error("You have not successfully authenticated with IAP")
    else:
        st.success("You came through IAP!")
        raw_header_username = st.context.headers["X-Goog-Authenticated-User-Email"]
        clean_username = raw_header_username.replace("accounts.google.com:", "")
        st.subheader(f"Welcome {clean_username}")

        user_id_from_jwt, user_email_from_jwt, error_str_from_jwt = validate_iap_jwt(st.context.headers["X-Goog-IAP-JWT-Assertion"], jwtaudience)

        if error_str_from_jwt:
            st.error(f"Error: {error_str_from_jwt}")
        else:
            st.success(f"Hi, {user_email_from_jwt}")


    with st.expander("See Headers:",expanded=False):
        st.context.headers
    
    with st.expander("See Cookies:", expanded=False):
        st.context.cookies




