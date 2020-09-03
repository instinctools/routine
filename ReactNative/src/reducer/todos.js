import Action from "../action/todos";
import ActionEditTodo from "../action/EditTodoAction";
import {Period, ResetType} from "../constants";


export const TODO_ACTION_STATE = {
    empty: {
        isProgress: false,
        isError: false
    },
    progress: {
        isProgress: true,
        isError: false
    },
    error: {
        isProgress: false,
        isError: true
    }
}


export const TODO_INITIAL_STATE = {
    todoActionState: TODO_ACTION_STATE.empty,
    todoFetchState: {
      isProgress: false,
      isError: false
    },
    items: [],
    selectedFilter: 'all',
    isScrollEnabled: true,
    menuActivation: {
        id: undefined,
        isMenuActivated: false
    },
    editTodo: {
        todoEditState: TODO_ACTION_STATE.empty,
        id: undefined,
        title: undefined,
        periods: [
            {
                periodUnit: Period.DAY,
                period: 1,
                isSelected: true
            },
            {
                periodUnit: Period.WEEK,
                period: 1,
                isSelected: false
            },
            {
                periodUnit: Period.MONTH,
                period: 1,
                isSelected: false
            }],
        periodSelector: null,
        resetType: ResetType.BY_PERIOD,
        success: false
    }
};

export const reducer = (state = TODO_INITIAL_STATE, action) => {
    const newState = {...state};
    switch (action.type) {
        case Action.Type.TODO_ACTION_STATE:
            newState.todoActionState = action.todoActionState
            break;
        case Action.Type.TODO_FETCH_STATE:
            newState.todoFetchState = action.todoFetchState
            break;
        case Action.Type.TODO_FETCH_RESULT:
            newState.todoFetchState = TODO_INITIAL_STATE.todoFetchState
            newState.items = action.todos;
            break;
        case Action.Type.TODO_ADD: {
            newState.items = [...newState.items];
            let index = newState.items.findIndex(todo => todo.id === action.todo.id);
            if (index > -1) {
                newState.items[index] = action.todo
            } else {
                newState.items.push(action.todo)
            }

            newState.editTodo = {
                ...TODO_INITIAL_STATE.editTodo,
                success: true
            };
            break;
        }
        case Action.Type.TODO_SELECT:
            newState.editTodo = {
                ...TODO_INITIAL_STATE.editTodo,
            };
            if (action.todo !== undefined) {
                newState.editTodo = {
                    ...newState.editTodo,
                    id: action.todo.id,
                    title: action.todo.title,
                    resetType: action.todo.resetType,
                    periods: newState.editTodo.periods.map((period) => {
                        let periodDay = 1
                        let isSelected = false
                        if (period.periodUnit === action.todo.periodUnit) {
                            isSelected = true
                            periodDay = action.todo.period
                        }
                        return {...period, period: periodDay, isSelected: isSelected}
                    })
                };
            }
            break;
        case Action.Type.TODO_EDIT_STATE:
            newState.editTodo = Object.assign({}, newState.editTodo, {
                todoEditState: action.todoEditState
            });
            break;
        case Action.Type.TODO_RESET: {
            newState.todoActionState = TODO_ACTION_STATE.empty
            newState.items = newState.items.map((todo, _) => {
                if (todo.id === action.item.id) {
                    return action.item
                }
                return todo
            });
            break;
        }
        case Action.Type.TODO_DELETE: {
            newState.todoActionState = TODO_ACTION_STATE.empty
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
                periods: newState.editTodo.periods.map((period) => {
                    let currentPeriod = period.period
                    if (period.periodUnit === newState.editTodo.periodSelector) {
                        currentPeriod = action.period
                    }
                    return {...period, period: currentPeriod}
                })
            };
            break;
        case ActionEditTodo.Type.TODO_EDIT_PERIOD_UNIT:
            newState.editTodo = {
                ...newState.editTodo,
                periods: newState.editTodo.periods.map((period) => {
                    let isSelected = false
                    if (period.periodUnit === action.periodUnit) {
                        isSelected = true
                    }
                    return {...period, isSelected: isSelected}
                })
            };
            break;
        case ActionEditTodo.Type.TODO_EDIT_CHANGE_PERIOD_SELECTOR:
            if (!action.isVisible) {
                newState.editTodo = {
                    ...newState.editTodo,
                    periodSelector: null
                };
            } else {
                newState.editTodo = {
                    ...newState.editTodo,
                    periodSelector: action.periodUnit
                };
            }
            break;
        case ActionEditTodo.Type.TODO_EDIT_CHANGE_RESET_TYPE:
            newState.editTodo = {
                ...newState.editTodo,
                resetType: action.resetType
            };
            break;
        default:
            return state;
    }
    return newState;
};
