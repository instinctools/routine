import auth from "@react-native-firebase/auth";

const SplashAction = {
    Type: {
        SPLASH_AUTH_PROGRESS: `SPLASH_AUTH_PROGRESS`,
        SPLASH_AUTH_SUCCESS: `SPLASH_AUTH_SUCCESS`,
        SPLASH_AUTH_ERROR: `SPLASH_AUTH_ERROR`
    }
};

SplashAction.startAuth = () => {
    return (dispatch) => {
        dispatch({
            type: SplashAction.Type.SPLASH_AUTH_PROGRESS
        });
        return auth()
            .signInAnonymously()
            .then(()=>{
                //TODO workaround to prevent error after successful login
                setTimeout(function() {
                    dispatch({
                            type: SplashAction.Type.SPLASH_AUTH_SUCCESS
                        }
                    )
                }, 500);
            })
    }
};

export default SplashAction
