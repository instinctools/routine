import React from 'react';
import {View} from 'react-native';
import {Text, TouchableRipple} from "react-native-paper";
import {todoDetailsStyle} from "../../styles/Styles";
import {connect} from "react-redux";
import ActionEditTodo from "../../action/EditTodoAction";
import {PeriodsList} from "../../constants";

const bgSelected = `#878787`;
const bgUnSelected = `#F1F1F1`;

const textSelected = `#F1F1F1`;
const textUnselected = `#878787`;

class PeriodSelector extends React.Component {
    render() {
        console.log(`PeriodSelector render props: ${JSON.stringify(this.props)}`);
        return <View style={{marginTop: 24}}>
            {PeriodsList.map(period => {
                return createButton(this.props, period)
            })}
        </View>
    }
}

const createButton = (props, period) => {
    const isSelected = period === props.selectedPeriodUnit;
    const bgColor = isSelected ? bgSelected : bgUnSelected;
    const textColor = isSelected ? textSelected : textUnselected;
    return <TouchableRipple
        style={{...todoDetailsStyle.periodSelectorContainer, backgroundColor: bgColor}}
        borderless={true}
        onPress={() => (props.editTodoPeriodUnit(period))}>
        <View style={todoDetailsStyle.periodSelectorContainerWrapper}>
            <Text style={{...todoDetailsStyle.periodSelectorText, color: textColor}}>
                Every {period.toLowerCase()}
            </Text>
            <View style={{...todoDetailsStyle.periodSelectorIndicator, backgroundColor: textColor}}/>
        </View>
    </TouchableRipple>
};

const mapStateToProps = (state) => {
    return {
        selectedPeriodUnit: state.todos.editTodo.periodUnit
    };
};


export default connect(
    mapStateToProps,
    ActionEditTodo
)(PeriodSelector);
