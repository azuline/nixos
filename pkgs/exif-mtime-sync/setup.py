import setuptools

setuptools.setup(
    name="exif-mtime-sync",
    version="0.0.0",
    python_requires=">=3.10.0",
    author="blissful",
    author_email="blissful@sunsetglow.net",
    license="Apache-2.0",
    entry_points={"console_scripts": ["exif-mtime-sync = exif_mtime_sync.__main__:main"]},
    packages=setuptools.find_namespace_packages(where="."),
    install_requires=[],
)
