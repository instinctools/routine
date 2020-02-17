import {Button, Picker, TextInput, View} from 'react-native';
import React from 'react';

const UNIT = ["DAY", "WEEK", "MONTH"];

export class CreateTodo extends React.Component {
    constructor() {
        super();
        this.state = {
            title: "",
            amount: 1,
            unit: UNIT[0]
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
                    <Picker.Item label={UNIT[0]} value={UNIT[0]}/>
                    <Picker.Item label={UNIT[1]} value={UNIT[1]}/>
                    <Picker.Item label={UNIT[2]} value={UNIT[2]}/>
                </Picker>
                <Button title={`SAVE CHANGES`} onPress={() =>
                    this.props.navigation.pop()
                }/>
            </View>
        );
    }
}
