import Action from "../action/todos";
import ActionEditTodo from "../action/EditTodoAction";
import {calculateTimestamp} from "../utils";
import {Period} from "../constants";

const _initialState = {
    items: [],
    selectedFilter: 'all',
    isScrollEnabled: true,
    menuActivation: {
        id: undefined,
        isMenuActivated: false
    }
};

const editTodoInitialState = {
    title: undefined,
    period: 1,
    periodUnit: Period.DAY
};

export const editTodoReducer = (state = editTodoInitialState, action) => {
    switch (action.type) {
        case ActionEditTodo.Type.TODO_EDIT_TITLE:
            return {...state, title: action.title};
        case ActionEditTodo.Type.TODO_EDIT_PERIOD:
            return {...state, period: action.period};
        case ActionEditTodo.Type.TODO_EDIT_PERIOD_UNIT:
            return {...state, periodUnit: action.periodUnit};
        default:
            return state;
    }
};

export const reducer = (state = _initialState, action) => {
    console.log(`reducer action: ${JSON.stringify(action)}`);
    const newState = {...state};
    switch (action.type) {
        case Action.Type.TODO_ADD: {
            newState.items = [
                ...newState.items,
                {
                    id: action.id,
                    title: action.title,
                    periodUnit: action.periodUnit,
                    period: action.period,
                    timestamp: calculateTimestamp(action.period, action.periodUnit)
                }
            ];
            break;
        }
        case Action.Type.TODO_EDIT: {
            newState.items = newState.items.map((todo, _) => {
                if (todo.id === action.id) {
                    return {
                        id: action.id,
                        title: action.title,
                        periodUnit: action.periodUnit,
                        period: action.period,
                        timestamp: calculateTimestamp(action.period, action.periodUnit)
                    }
                }
                return todo
            });
            break;
        }
        case Action.Type.TODO_RESET: {
            newState.items = newState.items.map((todo, _) => {
                if (todo.id === action.id) {
                    return Object.assign({}, todo, {
                        timestamp: calculateTimestamp(todo.period, todo.periodUnit)
                    })
                }
                return todo
            });
            break;
        }
        case Action.Type.TODO_DELETE: {
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
    }
    return newState;
};
