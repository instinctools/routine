import {Button, Picker, TextInput, View} from 'react-native';
import React from 'react';
import {PERIOD_DAY, PERIOD_MONTH, PERIOD_WEEK} from "../data/Reducer";


export class CreateTodo extends React.Component {
    constructor() {
        super();
        this.state = {
            title: "",
            periodUnit: PERIOD_DAY,
            period: 1
        }
    }

    render() {
        return (
            <View>
                <TextInput
                    placeholder="Enter amount"
                    onChangeText={text => this.setState({title: {text}})}
                />
                <Picker
                    selectedValue={this.state.unit}
                    onValueChange={(itemValue, _) => this.setState({unit: itemValue})}>
                    <Picker.Item label={PERIOD_DAY} value={PERIOD_DAY}/>
                    <Picker.Item label={PERIOD_WEEK} value={PERIOD_WEEK}/>
                    <Picker.Item label={PERIOD_MONTH} value={PERIOD_MONTH}/>
                </Picker>
                <Button title={`SAVE CHANGES`} onPress={() =>
                    this.props.navigation.pop()
                }/>
            </View>
        );
    }
}
