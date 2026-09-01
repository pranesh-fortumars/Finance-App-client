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

  getUsers: async () => {
    const q = query(FirebaseService.usersRef, orderBy("createdAt", "desc"));
    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => doc.data());
  },

  saveUser: async (user) => {
    await setDoc(doc(FirebaseService.usersRef, user.id), user);
  },

  saveUserScheme: async (userScheme) => {
    await setDoc(doc(FirebaseService.schemesRef, userScheme.id), userScheme);
  },

  generateNextSerialNumber: async () => {
    const q = query(FirebaseService.usersRef, orderBy("createdAt", "desc"), limit(1));
    const snapshot = await getDocs(q);
    if (snapshot.empty) return 'CUST001';
    
    const lastUser = snapshot.docs[0].data();
    const number = parseInt(lastUser.serialNumber.replace(/[^0-9]/g, '')) || 0;
    return `CUST${String(number + 1).padStart(3, '0')}`;
  }
};
