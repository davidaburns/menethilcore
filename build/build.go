package build

import "fmt"

const (
	BuildTypeDev    string = "dev"
	BuildTypeProd   string = "prod"
	BuildTypeUnkown string = "unkown"
)

var (
	name        = "osmom"
	version     = "0.0.1"
	buildNumber = "0"
	buildType   = BuildTypeUnkown
	buildCommit = ""
)

type BuildInfo struct {
	Name        string
	Version     string
	BuildNumber string
	BuildType   string
	BuildCommit string
}

func NewBuildInfo() *BuildInfo {
	return &BuildInfo{
		Name:        name,
		Version:     version,
		BuildNumber: buildNumber,
		BuildType:   buildType,
		BuildCommit: buildCommit,
	}
}

func (build *BuildInfo) String() string {
	return fmt.Sprintf("%s-%s.%s:b%s [%s]", build.Name, build.Version, build.BuildType, build.BuildNumber, build.BuildCommit)
}
