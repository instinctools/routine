import auth from "@react-native-firebase/auth";

const SplashAction = {
    Type: {
        SPLASH_AUTH_PROGRESS: `SPLASH_AUTH_PROGRESS`,
        SPLASH_AUTH_SUCCESS: `SPLASH_AUTH_SUCCESS`,
        SPLASH_AUTH_ERROR: `SPLASH_AUTH_ERROR`
    }
};

SplashAction.auth = () => {
    return (dispatch) => {
        dispatch({
            type: SplashAction.Type.SPLASH_AUTH
        });
        return auth()
            .signInAnonymously()
            .then(dispatch({
                    type: SplashAction.Type.SPLASH_AUTH_SUCCESS
                }
            ))
    }
};

export default SplashAction
