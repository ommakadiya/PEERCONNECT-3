// Static mock data for UI development and testing.

/// Represents a peer user displayed on the Connections page.
class ConnectionUser {
  final String id;
  final String name;
  final String role;        // jobRole or course
  final String company;     // company or university
  final String originCity;
  final List<String> connections; // IDs of connected users

  const ConnectionUser({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.originCity,
    this.connections = const [],
  });
}

class MockData {
  MockData._();

  // ── Parents / Professionals ──────────────────────────────────────────
  static final List<ConnectionUser> parents = [
    const ConnectionUser(
      id: 'p1',
      name: 'Rajesh Sharma',
      role: 'Senior Manager',
      company: 'Bank Manager',
      originCity: 'Delhi',
      connections: ['p2', 'p3'],
    ),
    const ConnectionUser(
      id: 'p2',
      name: 'Sunita Patel',
      role: 'Community Organizer',
      company: 'Homemaker',
      originCity: 'Ahmedabad',
      connections: ['p1'],
    ),
    const ConnectionUser(
      id: 'p3',
      name: 'Amit Verma',
      role: 'Tech Lead',
      company: 'Software Engineer',
      originCity: 'Bangalore',
      connections: ['p1'],
    ),
    const ConnectionUser(
      id: 'p4',
      name: 'Neha Singh',
      role: 'Creative Educator',
      company: 'Teacher',
      originCity: 'Lucknow',
    ),
    const ConnectionUser(
      id: 'p5',
      name: 'Rakesh Mehta',
      role: 'Startup Founder',
      company: 'Entrepreneur',
      originCity: 'Mumbai',
    ),
    const ConnectionUser(
      id: 'p6',
      name: 'Kavita Nair',
      role: 'Medical Professional',
      company: 'Doctor',
      originCity: 'Kochi',
    ),
    const ConnectionUser(
      id: 'p7',
      name: 'Sanjay Gupta',
      role: 'Finance Expert',
      company: 'CA',
      originCity: 'Delhi',
    ),
    const ConnectionUser(
      id: 'p8',
      name: 'Pooja Desai',
      role: 'UX/UI Specialist',
      company: 'Designer',
      originCity: 'Ahmedabad',
    ),
    const ConnectionUser(
      id: 'p9',
      name: 'Arvind Iyer',
      role: 'Academic',
      company: 'Professor',
      originCity: 'Chennai',
    ),
    const ConnectionUser(
      id: 'p10',
      name: 'Meena Joshi',
      role: 'Family Coordinator',
      company: 'Homemaker',
      originCity: 'Pune',
    ),
    const ConnectionUser(
      id: 'p11',
      name: 'Vikram Malhotra',
      role: 'Business Owner',
      company: 'Businessman',
      originCity: 'Delhi',
    ),
    const ConnectionUser(
      id: 'p12',
      name: 'Anita Roy',
      role: 'Content Creator',
      company: 'Writer',
      originCity: 'Kolkata',
    ),
    const ConnectionUser(
      id: 'p13',
      name: 'Deepak Yadav',
      role: 'Law Enforcement',
      company: 'Police Officer',
      originCity: 'Jaipur',
    ),
    const ConnectionUser(
      id: 'p14',
      name: 'Ritu Kapoor',
      role: 'Fashion Entrepreneur',
      company: 'Boutique Owner',
      originCity: 'Chandigarh',
    ),
    const ConnectionUser(
      id: 'p15',
      name: 'Nitin Agarwal',
      role: 'Market Analyst',
      company: 'Trader',
      originCity: 'Surat',
    ),
    const ConnectionUser(
      id: 'p16',
      name: 'Farah Khan',
      role: 'Dance Professional',
      company: 'Choreographer',
      originCity: 'Mumbai',
    ),
    const ConnectionUser(
      id: 'p17',
      name: 'Harish Pillai',
      role: 'Wellness Coach',
      company: 'Trainer',
      originCity: 'Trivandrum',
    ),
  ];

  // ── Students ─────────────────────────────────────────────────────────
  static final List<ConnectionUser> students = [
    const ConnectionUser(
      id: 's1',
      name: 'Rohan Sharma',
      role: 'Class 10',
      company: 'Delhi Public School',
      originCity: 'Delhi',
      connections: ['s2', 's3'],
    ),
    const ConnectionUser(
      id: 's2',
      name: 'Priya Sharma',
      role: 'Class 8',
      company: 'Delhi Public School',
      originCity: 'Delhi',
      connections: ['s1'],
    ),
    const ConnectionUser(
      id: 's3',
      name: 'Dhruv Patel',
      role: 'Class 9',
      company: 'Ahmedabad Central School',
      originCity: 'Ahmedabad',
      connections: ['s4'],
    ),
    const ConnectionUser(
      id: 's4',
      name: 'Mahi Patel',
      role: 'Class 7',
      company: 'Ahmedabad Central School',
      originCity: 'Ahmedabad',
      connections: ['s3'],
    ),
    const ConnectionUser(
      id: 's5',
      name: 'Arjun Verma',
      role: 'Class 11',
      company: 'Bangalore International School',
      originCity: 'Bangalore',
      connections: ['s6'],
    ),
    const ConnectionUser(
      id: 's6',
      name: 'Ananya Verma',
      role: 'Class 9',
      company: 'Bangalore International School',
      originCity: 'Bangalore',
      connections: ['s5'],
    ),
    const ConnectionUser(
      id: 's7',
      name: 'Kabir Verma',
      role: 'Class 6',
      company: 'Bangalore International School',
      originCity: 'Bangalore',
    ),
    const ConnectionUser(
      id: 's8',
      name: 'Isha Singh',
      role: 'Class 10',
      company: 'Lucknow High School',
      originCity: 'Lucknow',
    ),
    const ConnectionUser(
      id: 's9',
      name: 'Vivaan Singh',
      role: 'Class 8',
      company: 'Lucknow High School',
      originCity: 'Lucknow',
    ),
    const ConnectionUser(
      id: 's10',
      name: 'Aditi Mehta',
      role: 'Class 12',
      company: 'Mumbai Academy',
      originCity: 'Mumbai',
    ),
    const ConnectionUser(
      id: 's11',
      name: 'Kartik Mehta',
      role: 'Class 10',
      company: 'Mumbai Academy',
      originCity: 'Mumbai',
    ),
    const ConnectionUser(
      id: 's12',
      name: 'Zara Nair',
      role: 'Class 11',
      company: 'Kochi Central School',
      originCity: 'Kochi',
    ),
    const ConnectionUser(
      id: 's13',
      name: 'Aryan Nair',
      role: 'Class 9',
      company: 'Kochi Central School',
      originCity: 'Kochi',
    ),
    const ConnectionUser(
      id: 's14',
      name: 'Disha Nair',
      role: 'Class 7',
      company: 'Kochi Central School',
      originCity: 'Kochi',
    ),
    const ConnectionUser(
      id: 's15',
      name: 'Rishi Gupta',
      role: 'Class 12',
      company: 'Delhi Public School',
      originCity: 'Delhi',
    ),
    const ConnectionUser(
      id: 's16',
      name: 'Maya Gupta',
      role: 'Class 10',
      company: 'Delhi Public School',
      originCity: 'Delhi',
    ),
    const ConnectionUser(
      id: 's17',
      name: 'Aarav Desai',
      role: 'Class 9',
      company: 'Ahmedabad Central School',
      originCity: 'Ahmedabad',
    ),
    const ConnectionUser(
      id: 's18',
      name: 'Simran Desai',
      role: 'Class 8',
      company: 'Ahmedabad Central School',
      originCity: 'Ahmedabad',
    ),
    const ConnectionUser(
      id: 's19',
      name: 'Vikram Iyer',
      role: 'Class 11',
      company: 'Chennai International School',
      originCity: 'Chennai',
    ),
    const ConnectionUser(
      id: 's20',
      name: 'Shruti Iyer',
      role: 'Class 10',
      company: 'Chennai International School',
      originCity: 'Chennai',
    ),
    const ConnectionUser(
      id: 's21',
      name: 'Aditya Iyer',
      role: 'Class 8',
      company: 'Chennai International School',
      originCity: 'Chennai',
    ),
    const ConnectionUser(
      id: 's22',
      name: 'Neha Joshi',
      role: 'Class 12',
      company: 'Pune Academy',
      originCity: 'Pune',
    ),
    const ConnectionUser(
      id: 's23',
      name: 'Rohit Joshi',
      role: 'Class 10',
      company: 'Pune Academy',
      originCity: 'Pune',
    ),
    const ConnectionUser(
      id: 's24',
      name: 'Prerna Malhotra',
      role: 'Class 11',
      company: 'Delhi Public School',
      originCity: 'Delhi',
    ),
    const ConnectionUser(
      id: 's25',
      name: 'Saurav Roy',
      role: 'Class 10',
      company: 'Kolkata Public School',
      originCity: 'Kolkata',
    ),
    const ConnectionUser(
      id: 's26',
      name: 'Pooja Yadav',
      role: 'Class 9',
      company: 'Jaipur High School',
      originCity: 'Jaipur',
    ),
    const ConnectionUser(
      id: 's27',
      name: 'Divya Kapoor',
      role: 'Class 8',
      company: 'Chandigarh Academy',
      originCity: 'Chandigarh',
    ),
    const ConnectionUser(
      id: 's28',
      name: 'Karan Agarwal',
      role: 'Class 12',
      company: 'Surat Central School',
      originCity: 'Surat',
    ),
    const ConnectionUser(
      id: 's29',
      name: 'Sara Khan',
      role: 'Class 11',
      company: 'Mumbai Academy',
      originCity: 'Mumbai',
    ),
    const ConnectionUser(
      id: 's30',
      name: 'Ishaan Pillai',
      role: 'Class 8',
      company: 'Trivandrum High School',
      originCity: 'Trivandrum',
    ),
    const ConnectionUser(
      id: 's31',
      name: 'Esha Desai',
      role: 'Class 10',
      company: 'Bangalore International School',
      originCity: 'Bangalore',
    ),
    const ConnectionUser(
      id: 's32',
      name: 'Manav Patel',
      role: 'Class 11',
      company: 'Ahmedabad Central School',
      originCity: 'Ahmedabad',
    ),
    const ConnectionUser(
      id: 's33',
      name: 'Nisha Verma',
      role: 'Class 9',
      company: 'Bangalore International School',
      originCity: 'Bangalore',
    ),
  ];

  // ── All users combined ────────────────────────────────────────────────
  static List<ConnectionUser> get allUsers => [...parents, ...students];

  /// Returns users NOT already connected to [userId], as recommendations.
  static List<ConnectionUser> getRecommendations(String userId) {
    final me = allUsers.firstWhere(
      (u) => u.id == userId,
      orElse: () => const ConnectionUser(id: '', name: '', role: '', company: '', originCity: ''),
    );
    return allUsers.where((u) => u.id != userId && !me.connections.contains(u.id)).toList();
  }

  /// Returns users already connected to [userId].
  static List<ConnectionUser> getConnections(String userId) {
    final me = allUsers.firstWhere(
      (u) => u.id == userId,
      orElse: () => const ConnectionUser(id: '', name: '', role: '', company: '', originCity: ''),
    );
    return allUsers.where((u) => me.connections.contains(u.id)).toList();
  }
}
