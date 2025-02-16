import { useAuth0 } from '@auth0/auth0-react';

export const useAuth = () => {
  const {
    isAuthenticated,
    loginWithRedirect,
    logout,
    user,
    isLoading,
    getAccessTokenSilently,
  } = useAuth0();

  return {
    isAuthenticated,
    login: loginWithRedirect,
    logout: () => logout({ returnTo: window.location.origin }),
    user,
    isLoading,
    getToken: getAccessTokenSilently,
  };
}; 