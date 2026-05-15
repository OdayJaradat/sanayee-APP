/// Dashboard KPI statistics entity
class AdminDashboardStats {
  final int totalUsers;
  final int totalClients;
  final int totalProfessionals;
  final int openRequests;
  final int completedRequests;
  final int openReports;

  const AdminDashboardStats({
    required this.totalUsers,
    required this.totalClients,
    required this.totalProfessionals,
    required this.openRequests,
    required this.completedRequests,
    required this.openReports,
  });
}
