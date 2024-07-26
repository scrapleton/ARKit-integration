import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4, Quaternion, Vector3;
import 'dart:math';

class Ressource {

  static final instance = Ressource._();

  final Map<String, ARNode> _dict = {}; 

  var earthImageNode = ARNode(
    name: 'assets/trigger_earth.jpg',
    type: NodeType.localImage,
    uri: 'assets/earth.jpg',
    eulerAngles: Vector3(pi / 4, 0, 0),
    scale: Vector3(0.2, 0.2, 0.2),
  );

  var dinoWebChromaKeyNode = ARNode(
    name: 'assets/trigger_dino.png',
    type: NodeType.chromaKeyVideo,
    uri: "https://cdn.pixabay.com/video/2021/07/21/82318-577813568_large.mp4",
    scale: Vector3(0.5, 0.5, 0.5),
  );

  var duck3DModelNode = ARNode(
    name: 'assets/trigger_duck.png',
    type: NodeType.localGLTF2,
    uri: "assets/Duck.gltf",
    scale: Vector3(0.1, 0.1, 0.1),
    transformation: Matrix4.compose(Vector3.zero(), Quaternion.identity(), Vector3(0.5, 0.5, 0.5))
  );

  var movieWebVideoNode = ARNode(
    name: 'assets/trigger_video.jpg',
    type: NodeType.localVideo,
    uri: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    transformation: Matrix4.compose(Vector3.zero(), Quaternion.identity(), Vector3(0.3, 0.2, 0.3))
  );
  

  Ressource._(){
    _dict['assets/trigger_earth.jpg'] = earthImageNode;
    _dict['assets/trigger_dino.png'] = dinoWebChromaKeyNode;
    _dict['assets/trigger_duck.png'] = duck3DModelNode;
    _dict['assets/trigger_video.jpg'] = movieWebVideoNode;
  }

  Map<String, ARNode> getDict() {
    return _dict;
  }

  List<String> getKeys(){
    return _dict.keys.toList();
  }
}