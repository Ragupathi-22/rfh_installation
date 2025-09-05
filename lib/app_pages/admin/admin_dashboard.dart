import 'package:flutter/material.dart';
import 'package:rfhinstaller/app_utils/custom_widget/app_bar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allAsps = [];
  List<Map<String, dynamic>> _filteredAsps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAspList();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAspList() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final mockResponse = [
      {
        'name': 'Ananya Rao',
        'area': 'Indiranagar',
        'company': 'CoolAir Pvt Ltd',
        'invoiceCount': 12,
      },
      {
        'name': 'Rahul Verma',
        'area': 'Koramangala',
        'company': 'FreezeTech Services',
        'invoiceCount': 8,
      },
      {
        'name': 'Meera Iyer',
        'area': 'Whitefield',
        'company': 'Arctic HVAC',
        'invoiceCount': 20,
      },
      {
        'name': 'Vikram Singh',
        'area': 'HSR Layout',
        'company': 'BreezeWorks',
        'invoiceCount': 5,
      },
    ];
    setState(() {
      _allAsps = mockResponse;
      _filteredAsps = List<Map<String, dynamic>>.from(_allAsps);
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredAsps = List<Map<String, dynamic>>.from(_allAsps));
      return;
    }
    setState(() {
      _filteredAsps = _allAsps.where((asp) {
        final name = (asp['name'] ?? '').toString().toLowerCase();
        final area = (asp['area'] ?? '').toString().toLowerCase();
        final company = (asp['company'] ?? '').toString().toLowerCase();
        return name.contains(query) || area.contains(query) || company.contains(query);
      }).toList();
    });
  }

  void navigateToInvoicePage(Map<String, dynamic> asp) {
    // TODO: Replace with real navigation to Invoice Page and pass `asp`
    // Navigator.pushNamed(context, 'invoicePage', arguments: asp);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open invoices for ${asp['name']}')), // placeholder
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBarWidget(
        automaticallyImplyLeading: false,
        action: true,
        title: 'Admin Dashboard',),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildSearchBar(context),
              const SizedBox(height: 12),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredAsps.isEmpty
                        ? const Center(child: Text('No ASPs found'))
                        : ListView.builder(
                            itemCount: _filteredAsps.length,
                            itemBuilder: (context, index) {
                              final asp = _filteredAsps[index];
                              return _AspCard(
                                asp: asp,
                                colorScheme: colorScheme,
                                isWide: isWide,
                                onViewInvoice: () => navigateToInvoicePage(asp),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surface,
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search ASPs by name, area, or company',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _AspCard extends StatelessWidget {
  final Map<String, dynamic> asp;
  final ColorScheme colorScheme;
  final bool isWide;
  final VoidCallback onViewInvoice;

  const _AspCard({
    required this.asp,
    required this.colorScheme,
    required this.isWide,
    required this.onViewInvoice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.business,
              size: isWide ? 40 : 32,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (asp['company'] ?? '').toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _Chip(icon: Icons.person, label: asp['name'] ?? ''),
                      _Chip(icon: Icons.location_on, label: asp['area'] ?? ''),
                      _Chip(
                        icon: Icons.receipt_long,
                        label: 'Invoices: ${asp['invoiceCount'] ?? 0}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: onViewInvoice,
              child: const Text('View Invoice'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}


