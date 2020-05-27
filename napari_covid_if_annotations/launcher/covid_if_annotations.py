import h5py
import napari

from napari_covid_if_annotations.gui import connect_to_viewer, modify_layers
from napari_covid_if_annotations.layers import get_layers_from_file
from napari_covid_if_annotations._key_bindings import set_toggle_mode


def initialize_from_file(viewer, path, saturation_factor, edge_width):
    with h5py.File(path, 'r') as f:
        layers = get_layers_from_file(f, saturation_factor, edge_width)

    for (data, kwargs, layer_type) in layers:
        adder = getattr(viewer, f'add_{layer_type}')
        adder(data, **kwargs)


# should be installed as a script in setup.py
def launch_covid_if_annotation_tool(path=None, saturation_factor=1, edge_width=2):
    """ Launch the Covid IF anootation tool.

    Based on https://github.com/transformify-plugins/segmentify/blob/master/examples/launch.py
    """

    with napari.gui_qt():
        viewer = napari.Viewer()

        if path is not None:
            initialize_from_file(viewer, path,
                                 saturation_factor, edge_width)

        # connect the gui elements and modify layer functionality
        connect_to_viewer(viewer)
        modify_layers(viewer)

        # set the on click label toggle mode
        set_toggle_mode(viewer)

