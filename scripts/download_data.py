from pathlib import Path
import subprocess
import sys

PROJECT_DIRECTORY: Path = Path(__file__).parent.parent.absolute()
DATA_DIRECTORY: Path = PROJECT_DIRECTORY / "data"


def main():
    if DATA_DIRECTORY.exists():
        print(f"Found {DATA_DIRECTORY=})")
        sys.exit(0)

    DATA_DIRECTORY.mkdir(exist_ok=False)

    CDVAE_TARGET: Path = PROJECT_DIRECTORY / "temp"
    subprocess.call(
        [
            "git",
            "clone",
            "https://github.com/txie-93/cdvae.git",
            CDVAE_TARGET.as_posix(),
        ]
    )
    subprocess.call(
        [
            "mv",
            (CDVAE_TARGET / "data").as_posix(),
            PROJECT_DIRECTORY,
        ]
    )
    subprocess.call(
        [
            "rm",
            "-rf",
            CDVAE_TARGET.as_posix(),
        ]
    )


if __name__ == "__main__":
    main()
