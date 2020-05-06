import {FlatList} from 'react-native';
import React from 'react';
import {todoListStyle, toolbarStyle} from '../../styles/Styles';
import {connect} from "react-redux";
import Action from '../../action/todos';
import Icon from 'react-native-vector-icons/Ionicons';
import {TouchableRipple} from 'react-native-paper';
import TodoItem from "./TodoItem";
import {calculateTargetDate, pickColorBetween, prettyPeriod} from "../../utils";
import moment from "moment";

export const ITEM_TYPE_TODO = `ITEM_TYPE_TODO`;
export const ITEM_TYPE_SEPARATOR = `ITEM_TYPE_SEPARATOR`;
const SEPARATOR_ID = -1;

class TodoList extends React.PureComponent {

    static navigationOptions = ({navigation}) => {
        return {
            title: 'Routine',
            headerTitleStyle: toolbarStyle.title,
            headerRight: () => (
                <TouchableRipple style={toolbarStyle.menuItem}
                                 borderless={true}
                                 onPress={navigation.getParam('navigateToDetails')}>
                    <Icon name="md-add" size={24} color="#000000"/>
                </TouchableRipple>
            )
        }
    };

    componentDidMount() {
        this.props.navigation.setParams({
            navigateToDetails: () => (this.props.navigation.navigate(`Details`))
        });
    }

    render() {
        const {items, isScrollEnabled} = this.props;
        console.log(`TodoList render: items: ${JSON.stringify(items)}, isScrollEnabled: ${JSON.stringify(isScrollEnabled)}`);
        const uiItems = items ? toUiModels(items) : [];
        return (
            <FlatList style={{flex: 1}}
                      contentContainerStyle={todoListStyle.container}
                      scrollEnabled={isScrollEnabled}
                      data={uiItems}
                      keyExtractor={item => item.id}
                      renderItem={({item}) => <TodoItem item={item}/>}
            />
        );
    }
}

const mapStateToProps = (state) => ({
        items: state.todos.items,
        isScrollEnabled: state.todos.isScrollEnabled
    }
);

export default connect(mapStateToProps, Action)(TodoList)

const toUiModels = (todos) => {
    const currentTime = moment().startOf("day");
    const sortTodos = todos.slice().sort((value1, value2) => {
        return moment(value1.timestamp).diff(currentTime, `d`) - moment(value2.timestamp).diff(currentTime, `d`)
    });
    const uiTodos = [];
    let lastExpiredTodoFound = false;
    let lastExpiredTodoIndex = 0;
    for (let i = 0; i < sortTodos.length; i++) {
        const item = sortTodos[i];
        let todoTime = moment(item.timestamp);
        if (!lastExpiredTodoFound && !todoTime.isBefore(currentTime)) {
            if (uiTodos.length > 0) {
                uiTodos.push({
                    id: SEPARATOR_ID,
                    itemType: ITEM_TYPE_SEPARATOR
                });
                lastExpiredTodoIndex = i - 1;
            }
            lastExpiredTodoFound = true;
        }

        const todoColor = lastExpiredTodoFound ? pickColorBetween(i - lastExpiredTodoIndex + 1) : `#FF0000`;

        uiTodos.push({
            ...item,
            targetDate: calculateTargetDate(todoTime),
            periodStr: prettyPeriod(item.period, item.periodUnit),
            backgroundColor: todoColor,
            itemType: ITEM_TYPE_TODO
        })
    }
    return uiTodos;
};
