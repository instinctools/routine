import Action from "../action/todos";
import ActionEditTodo from "../action/EditTodoAction";
import {calculateTimestamp} from "../utils";
import {Period} from "../constants";
import uuid from "react-native-uuid";

export const TODO_INITIAL_STATE = {
    isFetching: false,
    isActionProgress: false,
    items: [],
    selectedFilter: 'all',
    isScrollEnabled: true,
    menuActivation: {
        id: undefined,
        isMenuActivated: false
    },
    editTodo: {
        id: undefined,
        title: undefined,
        period: 1,
        periodUnit: Period.DAY,
        isPeriodSelectorVisible: false
    }
};

export const reducer = (state = TODO_INITIAL_STATE, action) => {
    console.log(`reducer action: ${JSON.stringify(action)}`);
    const newState = {...state};
    switch (action.type) {
        case Action.Type.TODO_ACTION:
            newState.isActionProgress = true;
            break;
        case Action.Type.TODO_FETCH:
            newState.isFetching = true;
            break;
        case Action.Type.TODO_FETCH_RESULT:
            newState.isFetching = false;
            newState.items = action.todos;
            break;
        case Action.Type.TODO_ADD: {
            const newTodo = {...newState.editTodo, timestamp: calculateTimestamp(newState.editTodo.period, newState.editTodo.periodUnit)};
            delete newTodo.isPeriodSelectorVisible;
            if (newTodo.id) {
                newState.items = newState.items.map((todo, _) => {
                    if (todo.id === newTodo.id) {
                        return newTodo
                    }
                    return todo
                });
            } else {
                newState.items = [
                    ...newState.items, {
                        ...newTodo,
                        id: uuid.v1()
                    }
                ];
            }
            break;
        }
        case Action.Type.TODO_SELECT:
            if (action.id) {
                newState.editTodo = {
                    ...TODO_INITIAL_STATE.editTodo,
                    id: action.id,
                    title: action.title,
                    period: action.period,
                    periodUnit: action.periodUnit
                }
            } else {
                newState.editTodo = {
                    ...TODO_INITIAL_STATE.editTodo
                }
            }
            break;
        case Action.Type.TODO_RESET: {
            newState.items = newState.items.map((todo, _) => {
                if (todo.id === action.item.id) {
                    return action.item
                }
                return todo
            });
            break;
        }
        case Action.Type.TODO_DELETE: {
            newState.isActionProgress = false;
            newState.items = [...newState.items];
            const index = newState.items.map((item) => {
                return item.id;
            })
                .indexOf(action.id);
            if (index > -1) {
                newState.items.splice(index, 1);
            }
            break;
        }
        case Action.Type.TODO_CHANGE_MENU_ACTIVATION_STATE: {
            newState.items = newState.items.map((item) => {
                if (item.id === action.id) {
                    return Object.assign({}, item, {
                        isMenuActivated: action.isMenuActivated
                    })
                }
                return item
            });
            break;
        }
        case Action.Type.CHANGE_SCROLL_STATE: {
            newState.isScrollEnabled = action.isScrollEnabled;
            break;
        }
        case Action.Type.CHANGE_MENU_ACTIVATION_STATE: {
            newState.menuActivation = {
                id: action.id,
                isMenuActivated: action.isMenuActivated
            };
            break;
        }
        case ActionEditTodo.Type.TODO_EDIT_TITLE:
            newState.editTodo = {
                ...newState.editTodo,
                title: action.title
            };
            break;
        case ActionEditTodo.Type.TODO_EDIT_PERIOD:
            newState.editTodo = {
                ...newState.editTodo,
                period: action.period
            };
            break;
        case ActionEditTodo.Type.TODO_EDIT_PERIOD_UNIT:
            const isPeriodPickerVisible = action.periodUnit === Period.DAY;
            newState.editTodo = {
                ...newState.editTodo,
                periodUnit: action.periodUnit,
                isPeriodSelectorVisible: isPeriodPickerVisible
            };
            if (action.periodUnit !== Period.DAY) {
                newState.editTodo.period = 1
            }
            break;
        case ActionEditTodo.Type.TODO_EDIT_CHANGE_PERIOD_SELECTOR:
            newState.isActionProgress = false;
            newState.editTodo = {
                ...newState.editTodo,
                isPeriodSelectorVisible: action.isVisible
            };
            break;
        default:
            return state;
    }
    return newState;
};
