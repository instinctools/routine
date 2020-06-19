import React from "react";
import {ActivityIndicator, Image, Text, View} from "react-native";
import {connect} from "react-redux";
import SplashAction from "../../action/SplashAction";

class DetailsScreen extends React.Component {
    static navigationOptions = {
        header: null
    };

    render() {
        let splash = this.props.splash
        return <View style={{
            flex: 1,
            alignItems: 'stretch'
        }}>
            <View style={{flex: 1, justifyContent: 'center'}}>
                <Image
                    style={{width: 150, height: 150, alignSelf: `center`}}
                    source={require('./ic_launcher.png')}
                />

            </View>

            <View style={{flex: 1}}>
                <Text style={{
                    color: `#835D51`,
                    textAlign: "center",
                    fontSize: 18,
                    fontWeight: 'bold'
                }}>Setting up account</Text>
                {getProgress()}
            </View>
        </View>
    }
}


const getProgress = () => {
    return (Platform.OS === 'ios') ?
        <ActivityIndicator size="large"/> :
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
