class IndianAddressService {
  static const Map<String, List<String>> _statesAndDistricts = {
    'Andhra Pradesh': [
      'Anantapur', 'Chittoor', 'East Godavari', 'Guntur', 'Krishna', 'Kurnool',
      'Nellore', 'Prakasam', 'Srikakulam', 'Visakhapatnam', 'Vizianagaram', 'West Godavari', 'YSR Kadapa'
    ],
    'Arunachal Pradesh': [
      'Anjaw', 'Changlang', 'Dibang Valley', 'East Kameng', 'East Siang', 'Kamle',
      'Kra Daadi', 'Kurung Kumey', 'Lepa Rada', 'Lohit', 'Longding', 'Lower Dibang Valley',
      'Lower Siang', 'Lower Subansiri', 'Namsai', 'Pakke Kessang', 'Papum Pare', 'Shi Yomi',
      'Siang', 'Tawang', 'Tirap', 'Upper Siang', 'Upper Subansiri', 'West Kameng', 'West Siang'
    ],
    'Assam': [
      'Baksa', 'Barpeta', 'Biswanath', 'Bongaigaon', 'Cachar', 'Charaideo', 'Chirang',
      'Darrang', 'Dhemaji', 'Dhubri', 'Dibrugarh', 'Dima Hasao', 'Goalpara', 'Golaghat',
      'Hailakandi', 'Hojai', 'Jorhat', 'Kamrup', 'Kamrup Metropolitan', 'Karbi Anglong',
      'Karimganj', 'Kokrajhar', 'Lakhimpur', 'Majuli', 'Morigaon', 'Nagaon', 'Nalbari',
      'Sivasagar', 'Sonitpur', 'South Salmara-Mankachar', 'Tinsukia', 'Udalguri', 'West Karbi Anglong'
    ],
    'Bihar': [
      'Araria', 'Arwal', 'Aurangabad', 'Banka', 'Begusarai', 'Bhagalpur', 'Bhojpur',
      'Buxar', 'Darbhanga', 'East Champaran', 'Gaya', 'Gopalganj', 'Jamui', 'Jehanabad',
      'Kaimur', 'Katihar', 'Khagaria', 'Kishanganj', 'Lakhisarai', 'Madhepura', 'Madhubani',
      'Munger', 'Muzaffarpur', 'Nalanda', 'Nawada', 'Patna', 'Purnia', 'Rohtas', 'Saharsa',
      'Samastipur', 'Saran', 'Sheikhpura', 'Sheohar', 'Sitamarhi', 'Siwan', 'Supaul',
      'Vaishali', 'West Champaran'
    ],
    'Chhattisgarh': [
      'Balod', 'Baloda Bazar', 'Balrampur', 'Bastar', 'Bemetara', 'Bijapur', 'Bilaspur',
      'Dantewada', 'Dhamtari', 'Durg', 'Gariaband', 'Janjgir-Champa', 'Jashpur', 'Kabirdham',
      'Kanker', 'Kondagaon', 'Korba', 'Koriya', 'Mahasamund', 'Mungeli', 'Narayanpur',
      'Raigarh', 'Raipur', 'Rajnandgaon', 'Sukma', 'Surajpur', 'Surguja'
    ],
    'Delhi': [
      'Central Delhi', 'East Delhi', 'New Delhi', 'North Delhi', 'North East Delhi',
      'North West Delhi', 'Shahdara', 'South Delhi', 'South East Delhi', 'South West Delhi',
      'West Delhi'
    ],
    'Goa': [
      'North Goa', 'South Goa'
    ],
    'Gujarat': [
      'Ahmedabad', 'Amreli', 'Anand', 'Aravalli', 'Banaskantha', 'Bharuch', 'Bhavnagar',
      'Botad', 'Chhota Udaipur', 'Dahod', 'Dang', 'Devbhoomi Dwarka', 'Gandhinagar',
      'Gir Somnath', 'Jamnagar', 'Junagadh', 'Kheda', 'Kutch', 'Mahisagar', 'Mehsana',
      'Morbi', 'Narmada', 'Navsari', 'Panchmahal', 'Patan', 'Porbandar', 'Rajkot',
      'Sabarkantha', 'Surat', 'Surendranagar', 'Tapi', 'Vadodara', 'Valsad'
    ],
    'Haryana': [
      'Ambala', 'Bhiwani', 'Charkhi Dadri', 'Faridabad', 'Fatehabad', 'Gurugram',
      'Hisar', 'Jhajjar', 'Jind', 'Kaithal', 'Karnal', 'Kurukshetra', 'Mahendragarh',
      'Nuh', 'Palwal', 'Panchkula', 'Panipat', 'Rewari', 'Rohtak', 'Sirsa', 'Sonipat', 'Yamunanagar'
    ],
    'Himachal Pradesh': [
      'Bilaspur', 'Chamba', 'Hamirpur', 'Kangra', 'Kinnaur', 'Kullu', 'Lahaul and Spiti',
      'Mandi', 'Shimla', 'Sirmaur', 'Solan', 'Una'
    ],
    'Jharkhand': [
      'Bokaro', 'Chatra', 'Deoghar', 'Dhanbad', 'Dumka', 'East Singhbhum', 'Garhwa',
      'Giridih', 'Godda', 'Gumla', 'Hazaribagh', 'Jamtara', 'Khunti', 'Koderma',
      'Latehar', 'Lohardaga', 'Pakur', 'Palamu', 'Ramgarh', 'Ranchi', 'Sahibganj',
      'Seraikela Kharsawan', 'Simdega', 'West Singhbhum'
    ],
    'Karnataka': [
      'Bagalkot', 'Ballari', 'Belagavi', 'Bengaluru Rural', 'Bengaluru Urban', 'Bidar',
      'Chamarajanagar', 'Chikballapur', 'Chikkamagaluru', 'Chitradurga', 'Dakshina Kannada',
      'Davangere', 'Dharwad', 'Gadag', 'Hassan', 'Haveri', 'Kalaburagi', 'Kodagu',
      'Kolar', 'Koppal', 'Mandya', 'Mysuru', 'Raichur', 'Ramanagara', 'Shivamogga',
      'Tumakuru', 'Udupi', 'Uttara Kannada', 'Vijayapura', 'Yadgir'
    ],
    'Kerala': [
      'Alappuzha', 'Ernakulam', 'Idukki', 'Kannur', 'Kasaragod', 'Kollam', 'Kottayam',
      'Kozhikode', 'Malappuram', 'Palakkad', 'Pathanamthitta', 'Thiruvananthapuram', 'Thrissur', 'Wayanad'
    ],
    'Madhya Pradesh': [
      'Agar Malwa', 'Alirajpur', 'Anuppur', 'Ashoknagar', 'Balaghat', 'Barwani',
      'Betul', 'Bhind', 'Bhopal', 'Burhanpur', 'Chhatarpur', 'Chhindwara', 'Damoh',
      'Datia', 'Dewas', 'Dhar', 'Dindori', 'Guna', 'Gwalior', 'Harda', 'Hoshangabad',
      'Indore', 'Jabalpur', 'Jhabua', 'Katni', 'Khandwa', 'Khargone', 'Mandla',
      'Mandsaur', 'Morena', 'Narsinghpur', 'Neemuch', 'Panna', 'Raisen', 'Rajgarh',
      'Ratlam', 'Rewa', 'Sagar', 'Satna', 'Sehore', 'Seoni', 'Shahdol', 'Shajapur',
      'Sheopur', 'Shivpuri', 'Sidhi', 'Singrauli', 'Tikamgarh', 'Ujjain', 'Umaria', 'Vidisha'
    ],
    'Maharashtra': [
      'Ahmednagar', 'Akola', 'Amravati', 'Aurangabad', 'Beed', 'Bhandara', 'Buldhana',
      'Chandrapur', 'Dhule', 'Gadchiroli', 'Gondia', 'Hingoli', 'Jalgaon', 'Jalna',
      'Kolhapur', 'Latur', 'Mumbai City', 'Mumbai Suburban', 'Nagpur', 'Nanded',
      'Nandurbar', 'Nashik', 'Osmanabad', 'Palghar', 'Parbhani', 'Pune', 'Raigad',
      'Ratnagiri', 'Sangli', 'Satara', 'Sindhudurg', 'Solapur', 'Thane', 'Wardha',
      'Washim', 'Yavatmal'
    ],
    'Manipur': [
      'Bishnupur', 'Chandel', 'Churachandpur', 'Imphal East', 'Imphal West', 'Jiribam',
      'Kakching', 'Kamjong', 'Kangpokpi', 'Noney', 'Pherzawl', 'Senapati', 'Tamenglong',
      'Tengnoupal', 'Thoubal', 'Ukhrul'
    ],
    'Meghalaya': [
      'East Garo Hills', 'East Jaintia Hills', 'East Khasi Hills', 'North Garo Hills',
      'Ri Bhoi', 'South Garo Hills', 'South West Garo Hills', 'South West Khasi Hills',
      'West Garo Hills', 'West Jaintia Hills', 'West Khasi Hills'
    ],
    'Mizoram': [
      'Aizawl', 'Champhai', 'Hnahthial', 'Khawzawl', 'Kolasib', 'Lawngtlai', 'Lunglei',
      'Mamit', 'Saiha', 'Saitual', 'Serchhip'
    ],
    'Nagaland': [
      'Dimapur', 'Kiphire', 'Kohima', 'Longleng', 'Mokokchung', 'Mon', 'Peren',
      'Phek', 'Tuensang', 'Wokha', 'Zunheboto'
    ],
    'Odisha': [
      'Angul', 'Balangir', 'Balasore', 'Bargarh', 'Bhadrak', 'Boudh', 'Cuttack',
      'Deogarh', 'Dhenkanal', 'Gajapati', 'Ganjam', 'Jagatsinghpur', 'Jajpur',
      'Jharsuguda', 'Kalahandi', 'Kandhamal', 'Kendrapara', 'Kendujhar', 'Khordha',
      'Koraput', 'Malkangiri', 'Mayurbhanj', 'Nabarangpur', 'Nayagarh', 'Nuapada',
      'Puri', 'Rayagada', 'Sambalpur', 'Subarnapur', 'Sundargarh'
    ],
    'Punjab': [
      'Amritsar', 'Barnala', 'Bathinda', 'Faridkot', 'Fatehgarh Sahib', 'Fazilka',
      'Ferozepur', 'Gurdaspur', 'Hoshiarpur', 'Jalandhar', 'Kapurthala', 'Ludhiana',
      'Mansa', 'Moga', 'Muktsar', 'Pathankot', 'Patiala', 'Rupnagar', 'Sahibzada Ajit Singh Nagar',
      'Sangrur', 'Shahid Bhagat Singh Nagar', 'Tarn Taran'
    ],
    'Rajasthan': [
      'Ajmer', 'Alwar', 'Banswara', 'Baran', 'Barmer', 'Bharatpur', 'Bhilwara',
      'Bikaner', 'Bundi', 'Chittorgarh', 'Churu', 'Dausa', 'Dholpur', 'Dungarpur',
      'Hanumangarh', 'Jaipur', 'Jaisalmer', 'Jalore', 'Jhalawar', 'Jhunjhunu',
      'Jodhpur', 'Karauli', 'Kota', 'Nagaur', 'Pali', 'Pratapgarh', 'Rajsamand',
      'Sawai Madhopur', 'Sikar', 'Sirohi', 'Sri Ganganagar', 'Tonk', 'Udaipur'
    ],
    'Sikkim': [
      'East Sikkim', 'North Sikkim', 'South Sikkim', 'West Sikkim'
    ],
    'Tamil Nadu': [
      'Ariyalur', 'Chengalpattu', 'Chennai', 'Coimbatore', 'Cuddalore', 'Dharmapuri',
      'Dindigul', 'Erode', 'Kallakurichi', 'Kanchipuram', 'Karur', 'Krishnagiri',
      'Madurai', 'Mayiladuthurai', 'Nagapattinam', 'Namakkal', 'Nilgiris', 'Perambalur',
      'Pudukkottai', 'Ramanathapuram', 'Ranipet', 'Salem', 'Sivaganga', 'Tenkasi',
      'Thanjavur', 'Theni', 'Thoothukudi', 'Tiruchirappalli', 'Tirunelveli', 'Tirupathur',
      'Tiruppur', 'Tiruvallur', 'Tiruvannamalai', 'Tiruvarur', 'Vellore', 'Viluppuram', 'Virudhunagar'
    ],
    'Telangana': [
      'Adilabad', 'Bhadradri Kothagudem', 'Hyderabad', 'Jagtial', 'Jangaon', 'Jayashankar Bhupalapally',
      'Jogulamba Gadwal', 'Kamareddy', 'Karimnagar', 'Khammam', 'Komaram Bheem Asifabad',
      'Mahabubabad', 'Mahabubnagar', 'Mancherial', 'Medak', 'Medchal-Malkajgiri',
      'Mulugu', 'Nagarkurnool', 'Nalgonda', 'Narayanpet', 'Nirmal', 'Nizamabad',
      'Peddapalli', 'Rajanna Sircilla', 'Rangareddy', 'Sangareddy', 'Siddipet',
      'Suryapet', 'Vikarabad', 'Wanaparthy', 'Warangal Rural', 'Warangal Urban', 'Yadadri Bhuvanagiri'
    ],
    'Tripura': [
      'Dhalai', 'Gomati', 'Khowai', 'North Tripura', 'Sepahijala', 'South Tripura', 'Unakoti', 'West Tripura'
    ],
    'Uttar Pradesh': [
      'Agra', 'Aligarh', 'Allahabad', 'Ambedkar Nagar', 'Amethi', 'Amroha', 'Auraiya',
      'Ayodhya', 'Azamgarh', 'Baghpat', 'Bahraich', 'Ballia', 'Balrampur', 'Banda',
      'Barabanki', 'Bareilly', 'Basti', 'Bhadohi', 'Bijnor', 'Budaun', 'Bulandshahr',
      'Chandauli', 'Chitrakoot', 'Deoria', 'Etah', 'Etawah', 'Farrukhabad', 'Fatehpur',
      'Firozabad', 'Gautam Buddha Nagar', 'Ghaziabad', 'Ghazipur', 'Gonda', 'Gorakhpur',
      'Hamirpur', 'Hapur', 'Hardoi', 'Hathras', 'Jalaun', 'Jaunpur', 'Jhansi', 'Kannauj',
      'Kanpur Dehat', 'Kanpur Nagar', 'Kasganj', 'Kaushambi', 'Kheri', 'Kushinagar',
      'Lalitpur', 'Lucknow', 'Maharajganj', 'Mahoba', 'Mainpuri', 'Mathura', 'Mau',
      'Meerut', 'Mirzapur', 'Moradabad', 'Muzaffarnagar', 'Pilibhit', 'Pratapgarh',
      'Prayagraj', 'Raebareli', 'Rampur', 'Saharanpur', 'Sambhal', 'Sant Kabir Nagar',
      'Shahjahanpur', 'Shamli', 'Shravasti', 'Siddharthnagar', 'Sitapur', 'Sonbhadra',
      'Sultanpur', 'Unnao', 'Varanasi'
    ],
    'Uttarakhand': [
      'Almora', 'Bageshwar', 'Chamoli', 'Champawat', 'Dehradun', 'Haridwar', 'Nainital',
      'Pauri Garhwal', 'Pithoragarh', 'Rudraprayag', 'Tehri Garhwal', 'Udham Singh Nagar', 'Uttarkashi'
    ],
    'West Bengal': [
      'Alipurduar', 'Bankura', 'Birbhum', 'Cooch Behar', 'Dakshin Dinajpur', 'Darjeeling',
      'Hooghly', 'Howrah', 'Jalpaiguri', 'Jhargram', 'Kalimpong', 'Kolkata', 'Malda',
      'Murshidabad', 'Nadia', 'North 24 Parganas', 'Paschim Bardhaman', 'Paschim Medinipur',
      'Purba Bardhaman', 'Purba Medinipur', 'Purulia', 'South 24 Parganas', 'Uttar Dinajpur'
    ]
  };

  static const Map<String, List<String>> _districtCities = {
    // Major cities for each district (sample data - you can expand this)
    'Mumbai Suburban': ['Andheri', 'Bandra', 'Borivali', 'Goregaon', 'Jogeshwari', 'Kandivali', 'Malad', 'Santacruz'],
    'Mumbai City': ['Colaba', 'Fort', 'Marine Lines', 'Churchgate', 'Nariman Point', 'Worli', 'Parel', 'Dadar'],
    'Delhi': ['Central Delhi', 'New Delhi', 'South Delhi', 'East Delhi', 'North Delhi', 'West Delhi'],
    'Bangalore Urban': ['Bangalore', 'Electronic City', 'Whitefield', 'Koramangala', 'Indiranagar', 'Jayanagar'],
    'Chennai': ['Chennai', 'Anna Nagar', 'T. Nagar', 'Adyar', 'Velachery', 'Tambaram'],
    'Hyderabad': ['Hyderabad', 'Secunderabad', 'HITEC City', 'Gachibowli', 'Kondapur', 'Madhapur'],
    'Kolkata': ['Kolkata', 'Salt Lake', 'New Town', 'Dum Dum', 'Park Street', 'Ballygunge'],
    'Pune': ['Pune', 'Hinjewadi', 'Baner', 'Koregaon Park', 'Viman Nagar', 'Wakad'],
    'Ahmedabad': ['Ahmedabad', 'Gandhinagar', 'Vastrapur', 'Bodakdev', 'Satellite', 'Maninagar'],
    'Jaipur': ['Jaipur', 'C-Scheme', 'Vaishali Nagar', 'Pink City', 'Bani Park', 'Civil Lines'],
    'Lucknow': ['Lucknow', 'Gomti Nagar', 'Hazratganj', 'Alambagh', 'Indira Nagar', 'Rajajipuram'],
    'Kanpur': ['Kanpur', 'Cantt', 'Kalyanpur', 'Panki', 'Govind Nagar', 'Shyam Nagar'],
    'Nagpur': ['Nagpur', 'Civil Lines', 'Dharampeth', 'Sadar', 'Gandhibagh', 'Itwari'],
    'Indore': ['Indore', 'Rajwada', 'Sarafa Bazaar', 'Vijay Nagar', 'Bhawarkuan', 'Palasia'],
    'Bhopal': ['Bhopal', 'New Market', 'MP Nagar', 'Arera Colony', 'Shyamla Hills', 'Bairagarh'],
    'Visakhapatnam': ['Visakhapatnam', 'Dwaraka Nagar', 'MVP Colony', 'Rushikonda', 'Beach Road', 'Gajuwaka'],
    'Vadodara': ['Vadodara', 'Alkapuri', 'Fatehgunj', 'Sayajigunj', 'Akota', 'Tandalja'],
    'Ludhiana': ['Ludhiana', 'Model Town', 'Civil Lines', 'Sarabha Nagar', 'BRS Nagar', 'Punjabi Bagh'],
    'Agra': ['Agra', 'Taj Ganj', 'Fatehabad', 'Sikandra', 'Dayalbagh', 'Kamla Nagar'],
    'Nashik': ['Nashik', 'Gangapur Road', 'College Road', 'Satpur', 'Indira Nagar', 'Cidco'],
    'Faridabad': ['Faridabad', 'Sector 16', 'Sector 15', 'Ballabhgarh', 'Neharpar', 'Sector 28'],
    'Meerut': ['Meerut', 'Sardhana', 'Mawana', 'Hapur', 'Modinagar', 'Ghaziabad'],
    'Rajkot': ['Rajkot', 'Kalavad Road', 'University Road', 'Gondal Road', '150 Feet Ring Road', 'Kuvadva'],
    'Kalyan': ['Kalyan', 'Dombivli', 'Thane', 'Ulhasnagar', 'Ambernath', 'Badlapur'],
    'Vasai-Virar': ['Vasai', 'Virar', 'Nalasopara', 'Bhayandar', 'Mira Road', 'Boisar'],
    'Varanasi': ['Varanasi', 'Assi Ghat', 'Dashashwamedh Ghat', 'Manikarnika Ghat', 'BHU', 'Cantonment'],
    'Srinagar': ['Srinagar', 'Dal Lake', 'Hazratbal', 'Lal Chowk', 'Rajbagh', 'Jawahar Nagar'],
    'Jammu': ['Jammu', 'Bahu Fort', 'Raghunath Bazaar', 'Tawi', 'Gandhi Nagar', 'Channi'],
    'Chandigarh': ['Chandigarh', 'Sector 17', 'Sector 22', 'Sector 35', 'Panchkula', 'Mohali'],
    'Thiruvananthapuram': ['Thiruvananthapuram', 'Kowdiar', 'Vazhuthacaud', 'Pattom', 'Kesavadasapuram', 'Poojappura'],
    'Kochi': ['Kochi', 'Fort Kochi', 'Marine Drive', 'JLN Stadium', 'Panampilly Nagar', 'Kakkanad'],
    'Coimbatore': ['Coimbatore', 'RS Puram', 'Saibaba Colony', 'Peelamedu', 'Gandhipuram', 'Singanallur'],
    'Madurai': ['Madurai', 'Meenakshi Temple', 'Periyar Bus Stand', 'Anna Nagar', 'K. K. Nagar', 'Villapuram'],
    'Tiruchirapalli': ['Tiruchirapalli', 'Cantonment', 'Srirangam', 'Woraiyur', 'Thillai Nagar', 'K. K. Nagar'],
    'Salem': ['Salem', 'Hasthampatti', 'Suramangalam', 'Kondalampatti', 'Fairlands', 'Ammapet'],
    'Tirunelveli': ['Tirunelveli', 'Palayamkottai', 'Tirunelveli Junction', 'Melapalayam', 'Thachanallur', 'KTC Nagar'],
    'Erode': ['Erode', 'Perundurai', 'Bhavani', 'Gobichettipalayam', 'Sathyamangalam', 'Kodumudi'],
    'Tiruppur': ['Tiruppur', 'Kumarapalayam', 'Avinashi', 'Palladam', 'Dharapuram', 'Kangayam'],
    'Vellore': ['Vellore', 'Katpadi', 'Sathuvachari', 'Gandhi Nagar', 'Bodinayakkanur', 'Arani'],
    'Tuticorin': ['Tuticorin', 'Harbour', 'Tuticorin Port', 'Kovilpatti', 'Kayathar', 'Ottapidaram'],
    'Dindigul': ['Dindigul', 'Palani', 'Kodaikanal', 'Oddanchatram', 'Vedasandur', 'Natham'],
    'Thanjavur': ['Thanjavur', 'Kumbakonam', 'Pattukkottai', 'Orathanadu', 'Peravurani', 'Budalur'],
    'Kanchipuram': ['Kanchipuram', 'Sriperumbudur', 'Uthiramerur', 'Walajabad', 'Maduranthakam', 'Chengalpattu'],
    'Nagercoil': ['Nagercoil', 'Kanyakumari', 'Colachel', 'Padmanabhapuram', 'Thuckalay', 'Kuzhithurai'],
    'Cuddalore': ['Cuddalore', 'Chidambaram', 'Virudhachalam', 'Panruti', 'Kurinjipadi', 'Bhuvanagiri'],
    'Kumbakonam': ['Kumbakonam', 'Pattukkottai', 'Orathanadu', 'Peravurani', 'Budalur', 'Thiruvaiyaru'],
    'Tiruvannamalai': ['Tiruvannamalai', 'Arni', 'Polur', 'Chengam', 'Vandavasi', 'Cheyyar'],
    'Pollachi': ['Pollachi', 'Udumalpet', 'Valparai', 'Kinathukadavu', 'Anamalai', 'Amaravathi'],
    'Rajapalayam': ['Rajapalayam', 'Srivilliputhur', 'Sattur', 'Sivakasi', 'Virudhunagar', 'Aruppukkottai'],
    'Sivakasi': ['Sivakasi', 'Virudhunagar', 'Aruppukkottai', 'Rajapalayam', 'Srivilliputhur', 'Sattur'],
    'Virudhunagar': ['Virudhunagar', 'Aruppukkottai', 'Sivakasi', 'Rajapalayam', 'Srivilliputhur', 'Sattur'],
    'Karaikudi': ['Karaikudi', 'Devakottai', 'Sivaganga', 'Manamadurai', 'Ilayangudi', 'Kallal'],
    'Sivaganga': ['Sivaganga', 'Karaikudi', 'Devakottai', 'Manamadurai', 'Ilayangudi', 'Kallal'],
    'Ramanathapuram': ['Ramanathapuram', 'Rameswaram', 'Paramakudi', 'Mudukulathur', 'Kadaladi', 'Tiruvadanai'],
    'Thoothukudi': ['Thoothukudi', 'Kovilpatti', 'Kayathar', 'Ottapidaram', 'Vilathikulam', 'Sathankulam'],
    'Theni': ['Theni', 'Bodinayakkanur', 'Periyakulam', 'Cumbum', 'Andipatti', 'Uthamapalayam'],
    'Dharmapuri': ['Dharmapuri', 'Harur', 'Pennagaram', 'Palacode', 'Karimangalam', 'Nallampalli'],
    'Krishnagiri': ['Krishnagiri', 'Hosur', 'Denkanikottai', 'Bargur', 'Mathur', 'Uthangarai'],
    'Namakkal': ['Namakkal', 'Rasipuram', 'Tiruchengode', 'Paramathi Velur', 'Kolli Hills', 'Mohanur'],
    'Karur': ['Karur', 'Kulithalai', 'Kadavur', 'Aravakurichi', 'Krishnarayapuram', 'Thogamalai'],
    'Perambalur': ['Perambalur', 'Veppanthattai', 'Kunnam', 'Alathur', 'Sendurai', 'Veppur'],
    'Ariyalur': ['Ariyalur', 'Udayarpalayam', 'Sendurai', 'Andimadam', 'Varadarajanpettai', 'Jayankondam'],
    'Villupuram': ['Villupuram', 'Tindivanam', 'Gingee', 'Kandamangalam', 'Vanur', 'Marakkanam'],
    'Puducherry': ['Puducherry', 'Karaikal', 'Mahe', 'Yanam', 'Ozhukarai', 'Villianur'],
    'Karaikal': ['Karaikal', 'Nedungadu', 'Thirunallar', 'Kottucherry', 'Neravy', 'Tirumalairayanpattinam'],
    'Mahe': ['Mahe', 'Palloor', 'Chalakkara', 'Kallayi', 'Mukkam', 'Vadakara'],
    'Yanam': ['Yanam', 'Adavipalam', 'Korukonda', 'Mettakur', 'Ravulapalem', 'Kothapeta']
  };

  static List<String> getStates() {
    return _statesAndDistricts.keys.toList()..sort();
  }

  static List<String> getDistricts(String state) {
    return _statesAndDistricts[state] ?? [];
  }

  static List<String> getCities(String district) {
    return _districtCities[district] ?? ['City 1', 'City 2', 'City 3', 'City 4', 'City 5'];
  }

  static List<String> getAreas(String city) {
    // Sample areas for major cities
    return [
      'Area 1', 'Area 2', 'Area 3', 'Area 4', 'Area 5', 'Area 6', 'Area 7', 'Area 8'
    ];
  }

  static List<String> getPinCodes(String city) {
    // Sample pin codes (you can expand this with real data)
    return [
      '110001', '110002', '110003', '110004', '110005', '110006', '110007', '110008'
    ];
  }
}
