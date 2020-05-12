import {Modal, Text, View} from 'react-native';
import {Picker} from "react-native-wheel-datepicker";
import {TouchableRipple} from "react-native-paper";
import React from "react";
import {connect} from "react-redux";
import ActionEditTodo from "../../action/EditTodoAction";
import {todoDetailsStyle} from "../../styles/Styles";

const pickerData = () => {
    const array = [];
    for (let i = 1; i <= 100; i++) {
        array.push(i);
    }
    return array;
};


class PeriodSelector extends React.Component {
    render() {
        console.log(`PeriodSelector render props: ${JSON.stringify(this.props)}`);
        return <Modal animationType="slide"
                      visible={this.props.isVisible}
                      transparent={true}>
            <View
                style={todoDetailsStyle.periodSelectorContainer}>
                <View style={todoDetailsStyle.periodSelectorCancelWrapper}>
                    <TouchableRipple
                        style={todoDetailsStyle.periodSelectorCancel}
                        borderless={true}
                        onPress={() => this.props.changePeriodSelector(false)}>
                        <Text>Close</Text>
                    </TouchableRipple>
                   {/*REPLACE https://github.com/kalontech/ReactNativeWheelPicker*/}
                </View>
            </View>
        </Modal>

    }
}

const mapStateToProps = (state) => {
    return {
        period: state.todos.editTodo.period,
        isVisible: state.todos.editTodo.isPeriodSelectorVisible
    };
};


export default connect(
    mapStateToProps,
    ActionEditTodo
)(PeriodSelector);
