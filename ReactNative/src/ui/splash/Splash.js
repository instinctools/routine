import React from "react";
import {ActivityIndicator, Image, Text, View, Button} from "react-native";
import {connect} from "react-redux";
import SplashAction from "../../action/SplashAction";
import {TouchableRipple} from "react-native-paper";
import analytics from "@react-native-firebase/analytics";

class DetailsScreen extends React.Component {
    static navigationOptions = {
        header: null
    };

    render() {
        let {isProgress, isSuccess, isError} = this.props.splash
        if (isSuccess){
            props.navigation.navigate("Items")
        }
        let text = isProgress ? "Setting up account" : "An error occurred!"

        return <View style={{
            flex: 1,
        }}>
            <View style={{flex: 1, justifyContent: 'center'}}>
                <Image
                    style={{width: 196, height: 196, alignSelf: `center`}}
                    //TODO Check if it possible to replace by svg
                    source={require('./splash.png')}
                />

            </View>

            <View style={{flex: 1, alignItems: 'center'}}>
                <Text style={{
                    color: `#835D51`,
                    textAlign: "center",
                    fontSize: 18,
                    fontWeight: 'bold'
                }}>{text}</Text>
                {
                    isProgress ?
                        getProgress() :
                        <TouchableRipple
                            style ={{
                                justifyContent: `center`,
                                alignItems: `center`,
                                marginTop: 32,
                                borderRadius: 8,
                                backgroundColor: `#835D51`,
                                width: 156,
                                height: 50}}
                            onPress={() => {

                            }}
                            borderless={true}
                        >
                            <Text style={{fontSize: 16, color: `#ffffff`}}>Retry</Text>
                        </TouchableRipple>
                }
            </View>
        </View>
    }
}


const getProgress = () => {
    return (Platform.OS === 'ios') ?
        <ActivityIndicator style={{marginTop: 32}} size="large"/> :
        <ActivityIndicator style={{marginTop: 32}} color="#835D51" size={48}/>
}

const mapStateToProps = (state) => {
    return {
        splash: state.splash
    }
};

export default connect(
    mapStateToProps, {
        ...SplashAction
    }
)(DetailsScreen);
