import React from "react";
import {Text, View} from 'react-native';
import {todoDetailsStyle, todoListStyle} from "../../styles/Styles";
import {TouchableRipple} from "react-native-paper";
import {WheelPicker} from "react-native-wheel-picker-android";
import {connect} from "react-redux";
import ActionEditTodo from "../../action/EditTodoAction";
import StaticSafeAreaInsets from 'react-native-static-safe-area-insets';
import {StatusBar} from "react-native";
import {Period} from "../../constants";

const pickerData = () => {
    const array = [];
    for (let i = 1; i <= 100; i++) {
        array.push(i.toString());
    }
    return array;
};

class PeriodSelector extends React.Component {

    static navigationOptions = () => {
        return {
            headerShown: false,
            cardStyle: { backgroundColor: 'transparent' }
        }
    };

    periodUnit = this.props.navigation.getParam('periodUnit', Period.DAY)

    render() {
        const periodData = this.props.periods.find((period) => {
            return period.periodUnit === this.props.periodSelector;
        })

        const selectedItem = periodData != null ? periodData.period - 1: 0
        return <View
            style={todoDetailsStyle.periodSelectorContainer}>
            <StatusBar backgroundColor={'rgba(0, 0, 0, 0)'}/>
            <View style={{...todoDetailsStyle.periodSelectorCancelWrapper, paddingBottom: StaticSafeAreaInsets.safeAreaInsetsBottom}}>
                <View style={{flexDirection: `row`, justifyContent: `flex-end`}}>
                    <Text style={todoDetailsStyle.periodSelectorInfo}>Choose period</Text>
                    <TouchableRipple
                        style={todoDetailsStyle.periodSelectorCancel}
                        borderless={true}
                        onPress={() => this.props.navigation.pop()}>
                        <Text style={{fontSize: 16, fontWeight: `bold`}}>Done</Text>
                    </TouchableRipple>
                </View>
                <View style={{height: 1, backgroundColor: `#AAA9A9`}}/>
                <WheelPicker style={{width: `auto`, height: 196, marginTop: 24}}
                             selectedItem={selectedItem}
                             indicatorColor={`rgba(139, 139, 139, 0.87)`}
                             itemTextSize={24}
                             itemTextColor={`#9A99A2`}
                             selectedItemTextSize={24}
                             selectedItemTextColor={`#232326`}
                             data={pickerData()}
                             onItemSelected={value => this.props.editTodoPeriod(value + 1, this.periodUnit)}
                />
            </View>
        </View>
    }
}

const mapStateToProps = (state) => {
    return {
        periods: state.todos.editTodo.periods,
        periodSelector: state.todos.editTodo.periodSelector
    };
};


export default connect(
    mapStateToProps,
    ActionEditTodo
)(PeriodSelector);
