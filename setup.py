import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
    name="youtube-playman",
    version="1.0.0",
    author="Animesh Singh Chouhan",
    author_email="animeshsingh.iitkgp@gmail.com",
    description="Downloads and updates local copies of YouTube Playlists",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/animesh-chouhan/youtube-playman",
    project_urls={
        "Bug Tracker": "https://github.com/animesh-chouhan/youtube-playman/issues",
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    package_dir={"": "src"},
    packages=setuptools.find_packages(where="src"),
    python_requires=">=3.6",
)