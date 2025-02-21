import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:larid/database/customer_table.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/core/di/service_locator.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final Location _location = Location();
  LatLng _currentPosition = const LatLng(0, 0);
  bool _isLoading = true;
  final Set<Marker> _markers = {};
  List<CustomerEntity> _customers = [];
  CustomerEntity? _selectedCustomer;
  OverlayEntry? _overlayEntry;
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _getCurrentLocation();
    _loadCustomers();
  }

  Future<void> _loadMapStyle() async {
    try {
      final style = await rootBundle.loadString('assets/map/map_style.json');
      setState(() => _mapStyle = style);
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  @override
  void dispose() {
    _hideCustomerInfo();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) return;

      final locationData = await _location.getLocation();
      setState(() {
        _currentPosition = LatLng(
          locationData.latitude ?? 0,
          locationData.longitude ?? 0,
        );
        _isLoading = false;
      });

      _animateToCurrentLocation();
    } catch (e) {
      debugPrint('Error getting location: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).locationServicesRequired,
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return false;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).locationPermissionRequired,
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return false;
      }
    }

    return true;
  }

  void _animateToCurrentLocation() {
    if (_mapController != null && _currentPosition.latitude != 0) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 15),
        ),
      );
    }
  }

  Future<void> _loadCustomers() async {
    try {
      final customerTable = getIt<CustomerTable>();
      final customers = await customerTable.getAllSalesRepCustomers();
      setState(() {
        _customers = customers;
      });
      _addCustomerMarkers();
    } catch (e) {
      debugPrint('Error loading customers: $e');
    }
  }

  void _addCustomerMarkers() {
    for (final customer in _customers) {
      if (customer.mapCoords.isNotEmpty) {
        try {
          final coords = customer.mapCoords.split(',');
          if (coords.length == 2) {
            final lat = double.parse(coords[0]);
            final lng = double.parse(coords[1]);
            final marker = Marker(
              markerId: MarkerId(customer.customerCode),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
              onTap: () => _showCustomerInfo(customer, context),
            );
            setState(() {
              _markers.add(marker);
            });
          }
        } catch (e) {
          debugPrint(
            'Error adding marker for customer ${customer.customerCode}: $e',
          );
        }
      }
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.secondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryDark,
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }

  Future<void> _openInGoogleMaps(String mapCoords) async {
    try {
      final coords = mapCoords.split(',');
      if (coords.length == 2) {
        final lat = double.parse(coords[0]);
        final lng = double.parse(coords[1]);
        final url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
        );

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).cannotOpenGoogleMaps,
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error opening Google Maps: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).cannotOpenGoogleMaps),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showCustomerInfo(CustomerEntity customer, BuildContext context) {
    _hideCustomerInfo();

    final l10n = AppLocalizations.of(context);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
        bottom: 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        customer.customerName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _hideCustomerInfo,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.badge,
                  l10n.customerCode,
                  customer.customerCode,
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  Icons.location_on,
                  l10n.address,
                  customer.address,
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  Icons.phone,
                  l10n.phone,
                  customer.contactPhone,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openInGoogleMaps(customer.mapCoords),
                    icon: const Icon(Icons.directions),
                    label: Text(l10n.getDirections),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _selectedCustomer = null);
  }

  void _hideCustomerInfo() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _selectedCustomer = null);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
    _animateToCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.map),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _animateToCurrentLocation,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: _markers,
                    onTap: (_) => _hideCustomerInfo(),
                    mapType: MapType.normal,
                    style: _mapStyle,
                  ),
                ],
              ),
    );
  }
}
