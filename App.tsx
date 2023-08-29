import React, {useEffect} from 'react';
import {Text, View} from 'react-native';

const CleverTap = require('clevertap-react-native');

CleverTap.registerForPush();

CleverTap.addListener(CleverTap.CleverTapPushNotificationClicked, (e: any) => {
  console.log('Notification clicked:', e);
});

function App(): JSX.Element {
  useEffect(() => {
    CleverTap.onUserLogin({
      Name: 'Debug App Test',
      Identity: 'debug-app-test',
      Email: 'debug@test.com',
    });
  }, []);
  return (
    <View style={{backgroundColor: 'white', flex: 1}}>
      <Text>Hello world</Text>
    </View>
  );
}

export default App;
