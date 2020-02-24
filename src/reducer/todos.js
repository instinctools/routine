import Action from "../action/todos";
import moment from "moment";
import {Period} from "../constants";

const _initialState = {
    items: [],
    selectedFilter: 'all'
};

export const reducer = (state = _initialState, action) => {
    console.log(`reducer action: ${JSON.stringify(action)}`);
    const newState = { ...state };
    switch(action.type) {
        case Action.Type.TODO_ADD: {
            newState.items = [
                ...newState.items,
                {
                    id: action.id,
                    title: action.title,
                    periodUnit: action.periodUnit,
                    period: action.period,
                    timestamp: calculateTimestamp(action.periodUnit, action.period)
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
                        timestamp: calculateTimestamp(action.periodUnit, action.period)
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
                        timestamp: calculateTimestamp(todo.periodUnit, todo.period)
                    })
                }
                return todo
            });
            break;
        }
        case Action.Type.TODO_DELETE: {
            newState.items = [...newState.items];
            const index = newState.items.map((item) => { return item.id; })
                .indexOf(action.id);
            if (index > -1) {
                newState.items.splice(index, 1);
            }
            break;
        }
    }
    return newState;
};

const calculateTimestamp = (periodUnit, period) => {
    let date = moment();
    switch (periodUnit) {
        case Period.WEEK:
            date.add(period, `w`);
            break;
        case Period.MONTH:
            date.add(period, `M`);
            break;
        case Period.DAY:
        default:
            date.add(period, `d`);
            break;
    }
    return date.format("YYYY-MM-DD");
};
