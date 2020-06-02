import {ActivityIndicator, FlatList, Platform, RefreshControl, View} from 'react-native';
import React from 'react';
import {todoListStyle, toolbarStyle} from '../../styles/Styles';
import {connect} from "react-redux";
import Action from '../../action/todos';
import Icon from 'react-native-vector-icons/Ionicons';
import {TouchableRipple} from 'react-native-paper';
import TodoItem from "./TodoItem";
import {calculateTargetDate, pickColorBetween, prettyPeriod} from "../../utils";
import moment from "moment";
import analytics from "@react-native-firebase/analytics";

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
        this.props.requestTodos();

        this.props.navigation.setParams({
            navigateToDetails: () => {
                analytics().logEvent('add_todo_react', {});
                this.props.navigation.navigate(`Details`)
            }
        });
    }

    render() {
        const {items, isScrollEnabled, isFetching, isActionProgress} = this.props;
        console.log(`TodoList render: items: ${JSON.stringify(items)}, isScrollEnabled: ${JSON.stringify(isScrollEnabled)}`);
        const uiItems = items ? toUiModels(items) : [];
        if (isFetching && uiItems.length === 0) {
            return <View
                style={{
                    flex: 1,
                    justifyContent: 'center'
                }}>
                {getProgress()}
            </View>
        }
        return <View style={{
            flex: 1,
            justifyContent: 'center'
        }}>
            <FlatList style={{flex: 1}}
                      contentContainerStyle={todoListStyle.container}
                      scrollEnabled={isScrollEnabled}
                      data={uiItems}
                      keyExtractor={item => item.id}
                      renderItem={({item}) => <TodoItem item={item}/>}
                      refreshControl={
                          <RefreshControl refreshing={isFetching} onRefresh={() => {
                              this.props.requestTodos();
                          }}/>
                      }
            />{isActionProgress ? getProgress() : null}
        </View>
    }
}

const mapStateToProps = (state) => ({
        items: state.todos.items,
        isScrollEnabled: state.todos.isScrollEnabled,
        isFetching: state.todos.isFetching,
        isActionProgress: state.todos.isActionProgress
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

const getProgress = () => {
    return <View style={{flex: 1, justifyContent: "center", alignItems: "center", position: "absolute", alignSelf: "center"}}>{
        (Platform.OS === 'ios') ? <ActivityIndicator size="large"/> : <ActivityIndicator size={48}/>
    }
    </View>
};
