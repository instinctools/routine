import {combineReducers, createStore} from "redux";
import {todoReducer} from "./Reducer";

const reducer = combineReducers({todoReducer});
export const store = createStore(reducer);
