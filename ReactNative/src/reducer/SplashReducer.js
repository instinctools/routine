import SplashAction from "../action/SplashAction";

export const SPLASH_INITIAL_STATE = {
    isProgress: true,
    isSuccess: false,
    isError: false
}

export const splashReducer = (state = SPLASH_INITIAL_STATE, action) => {
    let newState = {
        isProgress: false,
        isSuccess: false,
        isError: false
    }
    switch (action.type) {
        case SplashAction.Type.SPLASH_AUTH_PROGRESS:
            newState.isProgress = true
            break
        case SplashAction.Type.SPLASH_AUTH_SUCCESS:
            newState.isSuccess = true
            break
        case SplashAction.Type.SPLASH_AUTH_ERROR:
            newState.isError = true
            break
        default:
            break;
    }
    return newState
}
