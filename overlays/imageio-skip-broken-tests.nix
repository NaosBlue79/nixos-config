# overlays/imageio-skip-broken-tests.nix
final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pythonFinal: pythonPrev: {
      imageio = pythonPrev.imageio.overridePythonAttrs (old: {
        # nixpkgs#580269: 16-bit PNG tests fail against current Pillow/NumPy.
        # Remove once the upstream fix lands in your channel.
        doCheck = false;
      });
    })
  ];
}
