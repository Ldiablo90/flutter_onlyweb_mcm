// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDzhUqitS_UrN9N6G8-85I2UjrDFSCSo9I",
  authDomain: "maccave-app.firebaseapp.com",
  projectId: "maccave-app",
  storageBucket: "maccave-app.appspot.com",
  messagingSenderId: "680151749830",
  appId: "1:680151749830:web:7676410143f952edd6b3c7",
  measurementId: "G-SWX7EYKGW4"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);