import { initializeApp } from "firebase/app";
import { getFirestore, collection, doc, setDoc, getDocs, query, orderBy, limit } from "firebase/firestore";

// Mirrored from your Flutter firebase_options.dart (Web Configuration)
const firebaseConfig = {
  apiKey: "AIzaSyC9jroSrB-k9nBuyE0XoTQnfDzuhHhjHD0",
  authDomain: "finance-tracker-app-1163f.firebaseapp.com",
  projectId: "finance-tracker-app-1163f",
  storageBucket: "finance-tracker-app-1163f.firebasestorage.app",
  messagingSenderId: "858604490005",
  appId: "1:858604490005:web:f51a795a9dd8ed997dad1c",
  measurementId: "G-MCEWVJWDBX"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// Mirrored from your Flutter firebase_service.dart
export const FirebaseService = {
  usersRef: collection(db, "users"),
  schemesRef: collection(db, "userSchemes"),
  transactionsRef: collection(db, "transactions"),
  schemeTypesRef: collection(db, "schemeTypes"),
  notificationsRef: collection(db, "notifications"),

  getUsers: async () => {
    const q = query(FirebaseService.usersRef, orderBy("createdAt", "desc"));
    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => doc.data());
  },

  getTransactions: async () => {
    const q = query(FirebaseService.transactionsRef, orderBy("date", "desc"));
    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => doc.data());
  },

  getUserSchemes: async () => {
    const snapshot = await getDocs(FirebaseService.schemesRef);
    return snapshot.docs.map(doc => doc.data());
  },

  getSchemeTypes: async () => {
    const snapshot = await getDocs(FirebaseService.schemeTypesRef);
    return snapshot.docs.map(doc => doc.data());
  },

  getNotifications: async () => {
    const q = query(FirebaseService.notificationsRef, orderBy("createdAt", "desc"));
    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => doc.data());
  },

  saveUser: async (user) => {
    await setDoc(doc(FirebaseService.usersRef, user.id), user);
  },

  saveUserScheme: async (userScheme) => {
    await setDoc(doc(FirebaseService.schemesRef, userScheme.id), userScheme);
  },

  saveTransaction: async (transaction) => {
    await setDoc(doc(FirebaseService.transactionsRef, transaction.id), transaction);
  },
  
  saveSchemeType: async (schemeType) => {
    await setDoc(doc(FirebaseService.schemeTypesRef, schemeType.id), schemeType);
  },

  saveNotification: async (notification) => {
    await setDoc(doc(FirebaseService.notificationsRef, notification.id), notification);
  },

  generateNextSerialNumber: async () => {
    const q = query(FirebaseService.usersRef, orderBy("createdAt", "desc"), limit(1));
    const snapshot = await getDocs(q);
    if (snapshot.empty) return 'c_01';
    
    const lastUser = snapshot.docs[0].data();
    const number = parseInt(lastUser.serialNumber.replace(/[^0-9]/g, '')) || 0;
    return `c_${String(number + 1).padStart(2, '0')}`;
  }
};
