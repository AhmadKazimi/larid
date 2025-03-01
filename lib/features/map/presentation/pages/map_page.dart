import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:larid/core/router/route_constants.dart';
import 'package:location/location.dart';
import 'package:go_router/go_router.dart';
import 'package:larid/database/customer_table.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';
import 'package:larid/core/di/service_locator.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle, SystemNavigator;
import 'package:url_launcher/url_launcher.dart';
import 'package:larid/core/storage/shared_prefs.dart';
import '../../domain/usecases/check_active_session_usecase.dart';
import '../../domain/usecases/start_session_usecase.dart';
import '../../domain/usecases/end_session_usecase.dart';
import '../../domain/repositories/working_session_repository.dart';
import 'package:larid/core/widgets/custom_dialog.dart';
import 'package:larid/core/widgets/custom_button.dart';

import '../widgets/session_clock_widget.dart';
import 'package:larid/core/widgets/gradient_page_layout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:larid/core/router/route_constants.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final Location _location = Location();
  LatLng _currentPosition = const LatLng(24.7136, 46.6753); // Default to Riyadh
  bool _isLoading = true;
  final Set<Marker> _markers = {};
  List<CustomerEntity> _customers = [];
  CustomerEntity? _selectedCustomer;
  bool _activeSession = false;
  DateTime? _sessionStartTime;
  OverlayEntry? _overlayEntry;
  String? _mapStyle;
  final CustomerTable _customerTable = getIt<CustomerTable>();
  final CheckActiveSessionUseCase _checkActiveSessionUseCase =
      getIt<CheckActiveSessionUseCase>();
  final StartSessionUseCase _startSessionUseCase = getIt<StartSessionUseCase>();
  final EndSessionUseCase _endSessionUseCase = getIt<EndSessionUseCase>();
  late final AppLocalizations l10n;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _getCurrentLocation();
    _loadCustomers();
    _checkWorkingSession();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context);
  }

  @override
  void dispose() {
    _hideCustomerInfo();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadMapStyle() async {
    try {
      final style = await rootBundle.loadString('assets/map/map_style.json');
      setState(() => _mapStyle = style);
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
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
              content: Text(l10n.locationServicesRequired),
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
              content: Text(l10n.locationPermissionRequired),
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
          CameraPosition(target: _currentPosition, zoom: 11),
        ),
      );
    }
  }

  Future<void> _loadCustomers() async {
    try {
      final customers = await _customerTable.getAllSalesRepCustomers();
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
      if (customer.mapCoords?.isNotEmpty ?? false) {
        try {
          final coords = customer.mapCoords!.split(',');
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

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value ?? '-',
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Future<void> _openInGoogleMaps(String? mapCoords) async {
    if (mapCoords == null || mapCoords.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noLocationAvailable),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

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
                content: Text(l10n.cannotOpenGoogleMaps),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.invalidCoordinates),
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
                        onPressed:
                            customer.mapCoords?.isNotEmpty ?? false
                                ? () => _openInGoogleMaps(customer.mapCoords)
                                : null,
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
                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            () => {
                              _hideCustomerInfo(),
                              context.push(
                                RouteConstants.customerActivity,
                                extra: customer,
                              ),
                            },

                        icon: const Icon(Icons.play_arrow),
                        label: Text(l10n.startVisit),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
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

  Future<void> _checkWorkingSession() async {
    try {
      final hasActiveSession = await _checkActiveSessionUseCase();
      if (hasActiveSession) {
        final session =
            await getIt<WorkingSessionRepository>().getCurrentSession();
        if (mounted) {
          setState(() {
            _activeSession = true;
            _sessionStartTime =
                session != null
                    ? DateTime.fromMillisecondsSinceEpoch(
                      session.startTimestamp,
                    )
                    : null;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _activeSession = false;
            _sessionStartTime = null;
          });
          _showStartSessionDialog(context);
        }
      }
    } catch (e) {
      debugPrint('Error checking working session: $e');
    }
  }

  Future<void> _startSession() async {
    try {
      await _startSessionUseCase();
      if (mounted) {
        // Verify session started successfully
        final hasActiveSession = await _checkActiveSessionUseCase();
        if (hasActiveSession) {
          final session =
              await getIt<WorkingSessionRepository>().getCurrentSession();
          if (session != null) {
            setState(() {
              _activeSession = true;
              _sessionStartTime = DateTime.fromMillisecondsSinceEpoch(
                session.startTimestamp,
              );
            });
            _hideCustomerInfo();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Started work session',
                  style: GoogleFonts.notoKufiArabic(),
                ),
                backgroundColor: AppColors.primary,
              ),
            );
          } else {
            // Session exists but couldn't get details
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error getting session details',
                  style: GoogleFonts.notoKufiArabic(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // Session didn't start
          setState(() {
            _activeSession = false;
            _sessionStartTime = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error starting session',
                style: GoogleFonts.notoKufiArabic(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error starting session: $e',
              style: GoogleFonts.notoKufiArabic(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrint('Error starting session: $e');
    }
  }

  Future<void> _endSession() async {
    final l10n = AppLocalizations.of(context);
    showCustomDialog(
      context: context,
      title: l10n.endSession,
      content: l10n.endSessionConfirmation,
      actions: [
        CustomButton(
          onPressed: () => Navigator.pop(context),
          text: l10n.cancel,
          isPrimary: false,
        ),
        CustomButton(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await _endSessionUseCase();
              if (mounted) {
                // Recheck session status
                final hasActiveSession = await _checkActiveSessionUseCase();
                if (!hasActiveSession) {
                  setState(() {
                    _activeSession = false;
                    _sessionStartTime = null;
                  });
                  _showStartSessionDialog(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.sessionEnded,
                        style: GoogleFonts.notoKufiArabic(),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                } else {
                  // Something went wrong, session is still active
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error: Session is still active',
                        style: GoogleFonts.notoKufiArabic(),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error ending session: $e',
                      style: GoogleFonts.notoKufiArabic(),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              debugPrint('Error ending session: $e');
            }
          },
          text: l10n.end,
          isPrimary: true,
        ),
      ],
    );
  }

  void _showStartSessionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showCustomDialog(
      context: context,
      barrierDismissible: false,
      title: l10n.startSession,
      content: l10n.noActiveSessionMessage,
      actions: [
        CustomButton(
          text: l10n.start,
          onPressed: () async {
            Navigator.of(context).pop();
            await _startSession(); // This will handle UI updates
          },
          isPrimary: true,
        ),
        CustomButton(
          text: l10n.cancel,
          onPressed: () {
            Navigator.of(context).pop();
            SystemNavigator.pop();
          },
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildCustomerInfoCard(CustomerEntity customer) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    customer.customerName,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _hideCustomerInfo,
                  color: AppColors.textColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.customerCode + ': ${customer.customerCode}',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 14,
                color: AppColors.textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  onPressed: () => _startSession(),
                  text: l10n.startSession,
                  isPrimary: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 20,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _markers,
            onTap: (_) => _hideCustomerInfo(),
            mapType: MapType.normal,
            style: _mapStyle,
            zoomControlsEnabled: false,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: AppColors.primary),
                      onPressed: () {
                        _hideCustomerInfo();
                        context.push('/customer-search');
                      },
                    ),
                  ),
                  SessionClockWidget(
                    isSessionActive: _activeSession,
                    sessionStartTime: _sessionStartTime,
                  ),
                ],
              ),
            ),
          ),
          if (_overlayEntry == null && _selectedCustomer != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildCustomerInfoCard(_selectedCustomer!),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'location',
            onPressed: _animateToCurrentLocation,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'end_session',
            onPressed: _endSession,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}
