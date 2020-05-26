import argparse

from napari_covid_if_annotations.launcher import launch_covid_if_annotation_tool

import vispy.app.backends._pyqt5

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--path', type=str, default=None)
    parser.add_argument('--saturation_factor', type=float, default=1)
    parser.add_argument('--edge_width', type=int, default=2)

    args = parser.parse_args()
    launch_covid_if_annotation_tool(args.path, args.saturation_factor, args.edge_width)


if __name__ == '__main__':
    main()
