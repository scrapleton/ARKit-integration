/// Determines which types of nodes the plugin supports
enum NodeType {
  localGLTF2, // Node with renderable with fileending .gltf in the Flutter asset folder
  webGLB, // Node with renderable with fileending .glb loaded from the internet during runtime
  fileSystemAppFolderGLB, // Node with renderable with fileending .glb in the documents folder of the current app
  fileSystemAppFolderGLTF2, // Node with renderable with fileending .gltf in the documents folder of the current app
  localImage, // Node with renderable with fileending .jpg, .jpeg, .png in the Flutter asset folder
  localVideo, // Node with renderable with fileending .mp4 in the Flutter asset folder
  chromaKeyVideo, // Node with renderable with fileending .mp4 in the Flutter asset folder
}
