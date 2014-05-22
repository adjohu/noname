module.exports = function(grunt) {
    grunt.initConfig({
        express: {
            default_option: {}
        },

        concurrent: {
            dev: {
                tasks: ['nodemon', 'watch'],
                options: {
                    logConcurrentOutput: true
                }
            }
        },
        nodemon: {
            dev: {
                script: './bin/www',
                options: {
                    nodeArgs: ['--debug'],
                    env: {
                        PORT: '3000'
                    },
                    // omit this property if you aren't serving HTML files and
                    // don't want to open a browser tab on start
                    callback: function (nodemon) {
                        nodemon.on('log', function (event) {
                            console.log(event.colour);
                        });

                        // opens browser on initial server start
                        nodemon.on('config:update', function () {
                            // Delay before server listens on port
                            setTimeout(function() {
                                require('open')('http://localhost:3000');
                            }, 1000);
                        });

                        // refreshes browser when server reboots
                        nodemon.on('restart', function () {
                            // Delay before server listens on port
                            setTimeout(function() {
                                require('fs').writeFileSync('.rebooted', 'rebooted');
                            }, 1000);
                        });
                    }
                }
            }
        },
        watch: {
                files: ['.rebooted', 'public/javascripts/*.coffee'],
                options: {
                    livereload: true,
                    host: 'localhost',
                    port: 35729
                }
            }
    });

    grunt.loadNpmTasks('grunt-concurrent')
    grunt.loadNpmTasks('grunt-express');
    grunt.loadNpmTasks('grunt-nodemon');
    grunt.loadNpmTasks('grunt-contrib-watch');


    grunt.registerTask('default', ['concurrent:dev']);
};