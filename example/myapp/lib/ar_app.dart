import 'package:ar_flutter_plugin_flutterflow/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ressources.dart';

class ArApp extends StatelessWidget {
  const ArApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ar Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 22, 221, 48)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'AR Demo for iOS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ARNode> nodes = [];

  late ARSessionManager sessionManager;
  late ARObjectManager objectManager;
  late ARAnchorManager anchorManager;
  late ARLocationManager locationManager;
  bool allowMultipleModels = false;
  bool addOnClick = false;
  ARNode currentAugmented = Ressource.instance.getDict().values.toList().first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 226, 176, 41),
            ),
            child: Text('Setting'),
          ),
          ListTile(
              title: Row(
            children: [
              const Text('Add on click (beta)'),
              Switch(
                  value: addOnClick,
                  onChanged: (bool value) {
                    setState(() {
                      addOnClick = value;
                    });
                  }),
            ],
          )),
          ListTile(
            title: DropdownMenu(
              initialSelection: currentAugmented,
              onSelected: (value) {
                setState(() {
                  if (value != null) {
                    currentAugmented = value;
                  }
                });
              },
              dropdownMenuEntries: Ressource.instance
                  .getDict()
                  .values
                  .toList()
                  .map<DropdownMenuEntry<ARNode>>((value) {
                return DropdownMenuEntry<ARNode>(
                    value: value, label: value.type.name);
              }).toList(),
            ),
          ),
          ListTile(
              title: Row(
            children: [
              const Text('Multiple Augmentations '),
              Switch(
                  value: allowMultipleModels,
                  onChanged: (bool value) {
                    setState(() {
                      allowMultipleModels = value;
                    });
                  }),
            ],
          )),
          ListTile(
            title: ElevatedButton(
                onPressed: () {
                  _removeObjects();
                },
                child: const Text("Remove placed Augmentations")),
          ),
        ],
      )),
      body: Center(
        child: ARView(
          onARViewCreated: _onARViewCreated,
          imageMarkers: Ressource.instance.getKeys(),
          planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
        ),
      ),
    );
  }

  void _onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    sessionManager = arSessionManager;
    objectManager = arObjectManager;
    anchorManager = arAnchorManager;
    locationManager = arLocationManager;

    sessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: false,
      showWorldOrigin: false,
    );
    objectManager.onInitialize();

    sessionManager.onPlaneDetected = (int planeAnchor) {
      //print('Plane detected: $planeAnchor');
    };

    sessionManager.onPlaneOrPointTap = _onPlaneTapped;

    sessionManager.onAugmentedImageDetected = (String imageMarker, pose) async {
      print('IMAGE DETECTED : $imageMarker');
      if (pose == null) {
        return;
      }
      _addNodeOnImageAnchor(imageMarker, pose);
    };
  }

  _addNodeOnImageAnchor(String name, Matrix4 pose) async {
    print("SEARCHING NODE FOR : $name");

    ARNode? node = Ressource.instance.getDict()[name];
    if (node != null) {
      var uri = node.uri;
      var type = node.type.name;
      print('ADDING NODE :');
      print(' - TYPE : $type');
      print(' - URI : $uri');
      if (await objectManager.addNode(node,
              anchor: ARImageAnchor(
                  transformation: pose, image: name, name: name)) !=
          null) {
        print("ADD NODE : SUCCEDD");
      } else {
        print("ADD NODE : FAILLURE");
      }
    } else {
      print("NODE NOT FOUND");
    }
  }

  _onPlaneTapped(List<ARHitTestResult> hitTestResults) async {
    if (addOnClick == false) {
      return;
    }

    if (allowMultipleModels == false) {
      _removeObjects();
    }

    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);

    var newNode = ARNode(
        type: currentAugmented.type,
        uri: currentAugmented.uri,
        scale: currentAugmented.scale,
        transformation: singleHitTestResult.worldTransform);
    bool? didAddWebNode = await objectManager.addNode(newNode);
    if (didAddWebNode == true) {
      nodes.add(newNode);
    }
  }

  _removeObjects() async {
    for (var node in nodes) {
      objectManager.removeNode(node);
    }
    nodes = [];
  }
}
